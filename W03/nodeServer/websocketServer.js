const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 3001 });

function sendRandomNumbers(ws) {
  let count = Math.floor(Math.random() * (10000 - 1000 + 1)) + 1000; // 3초 동안 보낼 메시지 수 (1천 ~ 1만)
  let numbersSent = 0;
  let sum = 0;
  let duration = 3000; // 메시지를 보내는 기간 (3초)

  const sendNumber = () => {
    if (ws.readyState === WebSocket.OPEN && numbersSent < count) {
      const randomNumber = Math.floor(Math.random() * 101); // 0에서 100 사이의 랜덤한 정수
      ws.send(randomNumber.toString());
      sum += randomNumber;
      numbersSent++;
      if (numbersSent < count) {
        setTimeout(sendNumber, duration / count); // 3초 동안 균일하게 분배
      } else {
        setTimeout(() => ws.send(`Sum: ${sum}`), 1000); // 총합 전송 후 1초 쉼
        setTimeout(resetAndStart, 2000); // 1초 후 다시 시작
      }
    }
  };

  const resetAndStart = () => {
    // 초기화 및 새로운 사이클 시작
    numbersSent = 0;
    sum = 0;
    count = Math.floor(Math.random() * (10000 - 1000 + 1)) + 1000;
    sendNumber();
  };

  sendNumber();
}

// 웹소켓 연결이 성립되면, sendRandomNumbers 함수 호출
console.log('Successfully connected')
wss.on('connection', function connection(ws) {
  sendRandomNumbers(ws);
});
