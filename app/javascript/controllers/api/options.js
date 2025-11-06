function cr(method, subUrl, handler, text, color) {
  const url = `/api/v1/${subUrl}`;
  const getUrl = (id) => `${url}/${id}`;
  return { method, url, handler, text, color, getUrl };
}

const colors = {
  friday: '#5cb85c',
  saturday: '#5bc0de',
  sunday: '#f0ad4e',
  monday: '#d9534f',
  default: '#F0F0F0'
}

export const API_OPTIONS = {
  Asst: cr('PUT', 'assist', 'renderAssistance', 'Asistencia', colors.default),
  F_V3: cr('PUT', 'food/v/3', 'renderFood', 'Cena Viernes', colors.friday),
  F_S1: cr('PUT', 'food/s/1', 'renderFood', 'Desayuno Sábado', colors.saturday),
  F_S2: cr('PUT', 'food/s/2', 'renderFood', 'Comida Sábado', colors.saturday),
  F_S3: cr('PUT', 'food/s/3', 'renderFood', 'Cena Sábado', colors.saturday),
  F_D1: cr('PUT', 'food/d/1', 'renderFood', 'Desayuno Domingo', colors.sunday),
  F_D2: cr('PUT', 'food/d/2', 'renderFood', 'Comida Domingo', colors.sunday),
  F_D3: cr('PUT', 'food/d/3', 'renderFood', 'Cena Domingo', colors.sunday),
  F_L1: cr('PUT', 'food/l/1', 'renderFood', 'Desayuno Lunes', colors.monday),
  Ping: cr('GET', 'ping', 'renderPing', 'Ping', colors.default),
}
