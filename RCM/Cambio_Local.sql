--
--  Cambio de Local
--
declare
    par_salida number := 131615;
    par_local_nuevo number := 31;--914;
    par_local_antiguo number := 914;--914;
begin
    JSYB_FND_FUNCIONES.Jsyb_Fnd_Set_Empresa( 1 );
    
    update  SALIDAS_DET
        set lo_codigo = par_local_nuevo
    where   numero = par_salida
        and lo_codigo = par_local_antiguo;
    
    update  BANDEJAS
        set lo_codigo = par_local_nuevo
    where   numero = par_salida
        and lo_codigo = par_local_antiguo;
    
    commit;
end;
