
class Personaje{
    const miCasa
    var property conyuges
    var property casado = false 
    var property acompaniantes = []
    var property estoyVivo = true
    var personalidad

    method esMicasa(unaCasa) = unaCasa == miCasa 

    method mePuedoCasarCon(unPersonaje) = return miCasa.sePuedeCasar(self) && unPersonaje.miCasa().sePuedeCasar(unPersonaje)
    method tengoSoloUnaPareja()         = return conyuges == 1
    method mismaCasa(otroPersonaje)     = return esMicasa(otroPersonaje.miCasa)

    method casarmeCon(otroPersonaje){
        if(!self.mePuedoCasarCon(otroPersonaje)){
            self.error("Error: no se pueden casar")
        }
        self.casar(otroPersonaje)
    }

    method casar(otroPersonaje){
        self.casado(true)
        otroPersonaje.casado(true)
    }

    method patrimonio() = return miCasa.patrimonio() / miCasa.miembros().size()
    method estoySolo()  = return acompaniantes.size() == 0
    method aliados()    = return [conyuges, acompaniantes, miCasa.miembros()].flatten()

    method esAliado(unPersonaje) = returnself.aliados().contains(unPersonaje)

    method soyPeligroso() = return estoyVivo && (self.patrimonioDeLosAliados || self.conyugesRicos() || self.alianzaPeligrosa())

    method patrimonioDeLosAliados() = self.aliados().sum{unAliado => unAliado.patrimonio()}
    method conyugesRicos()  = conyuges.all{unConyuge => unConyuge.soyDeCasaRica()}

    method soyDeCasaRica() = return miCasa.soyRica()
    method alianzaPeligrosa() = aliados.any{unAliado => unAliado.soyPeligroso()}

    method realizarAccion(objetivo) = personalidad.accion(objetivo)

    method meMataron() = self.estoyVivo(false)

    method derrocharDeMiCasa(porcentaje) = miCasa.perderDelPatrimonio(porcentaje)


}

//---------------------------------------------------------------------------------------
//--------------------------------ANIMALES-----------------------------------------------
//---------------------------------------------------------------------------------------

class Animal{

    method method patrimonio() = 0 
}

class Dragon inherits Animal{

    method soyPeligroso() = return true 
    
}

class Lobo inherits Animal{
    const soyHuargo

    method soyPeligroso() = return soyHuargo
}

//---------------------------------------------------------------------------------------
//--------------------------------------------------------------------CASAS--------------
//---------------------------------------------------------------------------------------

class Casa{
    var property miembros = []
    var property patrimonio

    method sePuedeCasar()
    method soyRica = return patrimonio > 1000

    method perderDelPatrimonio(porcentaje){
        patrimonio -= patrimonio *porcentaje
    }

   // method patrimonio() = return patrimonio() / miembros.size()
  

}

object lannister inherits Casa{
    

    override method sePuedeCasar(unPersonaje)= return unPersonaje.tengoSoloUnaPareja() 
}

object stark inherits Casa{

    override method sePuedeCasar(unPersonaje) = return miembros.all{otroPersonaje => !unPersonaje.mismaCasa(otroPersonaje)}
}

object guardiaDeLaNoche inherits Casa{

    override method sePuedeCasar(unPersonaje) = false
}

//---------------------------------------------------------------------------------------
//-------------------------------CONSPIRACIONES------------------------------------------
//---------------------------------------------------------------------------------------


object construtor{

    //method crearConspiracion() = const nuevaConspiracion = new Conspiracion(objetivo = new Personaje(), complotados =[] )

    method crearConspiracion(unObjetivo, unosCommplotados){
        const nuevaConspiracion = new Conspiracion(objetivo= unObjetivo, complotados = unosCommplotados)
    }

}

class Cosnpiracion{
    const objetivo 
    const complotados = []

    override method iniciaize(){
        complotados.all{unComplotado => unComplotado.soyPeligroso()}
    }

    method ejecutarConspiracion(){
        complotados.forEach{unComplotado => unComplotado.realizarAccion(objetivo)}
    }

    method cantidadDeTraidores() = {
        return complotados.filter{unComplotado => unComplotado.esAliado(objetivo)}.size()
    }
    
    method objetivoCumplido(){
        
    }
}

//-------------------------PERSONALIDADES-----------------------------------------------------

const casas = [lannister, stark, guardiaDeLaNoche]

object sutiles{

    method accion(objetivo){
       const casaMasPobre = casas.min{unaCasa => unaCasa.patrimonio()}
       const novio = casaMasPobre.miembros().find{unMiembro => !unMiembro.casado()}
       objetivo.casarmeCon(novio) //ya tira un error de por si
    }
}

object asesinos{

    method accion(objetivo){
        objetivo.meMataron()
    }
    
}

object asesinosPrecavidos{

    method accion(objetivo){
        if(!objetivo.casado()){
            objetivo.meMataron()
        }
    }
}

object disipados{
    const porcentajeParaDerrochar
    method accion(objetivo) = objetivo.derrocharDeMiCasa(porcentajeParaDerrochar)
}

object miedosos{

    method accion(objetivo){

    }
}