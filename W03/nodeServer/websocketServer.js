const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 3001 });

function sendRandomNumbers(ws) {
  let count = Math.floor(Math.random() * (10 - 1 + 1)) + 1;
  let numbersSent = 0;
  let sum = 0;
  let delayBetweenMessages = 300;

  const sendNumber = () => {
    if (ws.readyState === WebSocket.OPEN) {
      if (numbersSent < count) {
        const randomNumber = Math.floor(Math.random() * 101);
        ws.send(randomNumber.toString());
        sum += randomNumber;
        numbersSent++;
        setTimeout(sendNumber, delayBetweenMessages);
      } else {
        ws.send(`Sum: ${sum}`);
        setTimeout(() => {
          numbersSent = 0;
          sum = 0;
          count = Math.floor(Math.random() * (10 - 1 + 1)) + 1;
          sendNumber(); 
        }, 1000);
      }
    }
  };

  sendNumber();
}

wss.on('connection', function connection(ws) {
  console.log('Client connected');
  sendRandomNumbers(ws);

  ws.on('close', function close() {
    console.log('Client disconnected');
  });
});

console.log('WebSocket server is running on ws://localhost:3001');
