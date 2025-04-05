String getImageExtension(int id) {
  const Map<int, String> imageExtensions = {
    1: 'jpg',
    2: 'png',
    3: 'jpeg',
    4: 'dcm',
  };

  return imageExtensions[id] ?? 'unknown';
}
