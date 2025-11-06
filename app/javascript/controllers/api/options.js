function cr(method, subUrl, text, color) {
  const url = `/api/v1/${subUrl}`;
  const getUrl = (id) => `${url}/${id}`;
  return { method, url, text, color, getUrl };
}

const colors = {
  friday: '#5cb85c',
  saturday: '#5bc0de',
  sunday: '#f0ad4e',
  monday: '#d9534f',
  default: '#F0F0F0'
}

export const API_OPTIONS = {
  Asst: cr('PUT', 'assist', 'Asistencia', colors.default),
  F_V3: cr('PUT', 'food/v/3', 'Cena Viernes', colors.friday),
  F_S1: cr('PUT', 'food/s/1', 'Desayuno Sábado', colors.saturday),
  F_S2: cr('PUT', 'food/s/2', 'Comida Sábado', colors.saturday),
  F_S3: cr('PUT', 'food/s/3', 'Cena Sábado', colors.saturday),
  F_D1: cr('PUT', 'food/d/1', 'Desayuno Domingo', colors.sunday),
  F_D2: cr('PUT', 'food/d/2', 'Comida Domingo', colors.sunday),
  F_D3: cr('PUT', 'food/d/3', 'Cena Domingo', colors.sunday),
  F_L1: cr('PUT', 'food/l/1', 'Desayuno Lunes', colors.monday),
  Ping: cr('GET', 'ping', 'Ping', colors.default),
}
