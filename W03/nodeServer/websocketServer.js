const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 3001 });

wss.on('connection', function connection(ws) {
  console.log('Client connected');

  const sendRandomNumber = () => {
    if (ws.readyState === WebSocket.OPEN) {
      const randomNumber = Math.floor(Math.random() * 100); // 0에서 99 사이의 랜덤 숫자
      ws.send(randomNumber.toString());
    }
  };

  // 100ms마다 랜덤 숫자 전송 (초당 10번)
  const intervalId = setInterval(sendRandomNumber, 100);

  ws.on('close', function close() {
    console.log('Client disconnected');
    clearInterval(intervalId); // 클라이언트 연결이 끊어지면 인터벌을 멈춤
  });
});

console.log('WebSocket server is running on ws://localhost:3001');
