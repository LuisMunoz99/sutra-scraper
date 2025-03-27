import requests
from bs4 import BeautifulSoup

# URL base del portal SUTRA
BASE_URL = 'https://sutra.oslpr.org/'

def obtener_enlaces_medidas():
    """
    Función para extraer los enlaces de las medidas legislativas desde el portal SUTRA.
    """
    # Realizar una solicitud GET a la página principal
    respuesta = requests.get(BASE_URL)
    
    # Verificar que la solicitud fue exitosa (código 200)
    if respuesta.status_code == 200:
        # Analizar el contenido HTML de la página
        sopa = BeautifulSoup(respuesta.text, 'html.parser')
        
        # Encontrar todos los enlaces que llevan a medidas legislativas
        enlaces = sopa.find_all('a', href=True)
        
        # Filtrar los enlaces relevantes y construir URLs completas
        enlaces_medidas = [BASE_URL + enlace['href'] for enlace in enlaces if 'Medida' in enlace['href']]
        
        return enlaces_medidas
    else:
        print(f'Error al acceder a {BASE_URL}: Código {respuesta.status_code}')
        return []

if __name__ == '__main__':
    enlaces = obtener_enlaces_medidas()
    print(f'Se encontraron {len(enlaces)} medidas legislativas.')
    for enlace in enlaces:
        print(enlace)

