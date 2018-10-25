--
--  Reset RC
--
declare
    vl_local number := 31;--914;
    vl_salida number := 131615;
    vl_empresa number := 1;
    vl_org_inv number := 228;
    vl_org_loc number := 5;
    vl_org_cd number := 2;
begin
    JSYB_FND_FUNCIONES.Jsyb_Fnd_Set_Empresa( 1 );
    
    update  SALIDAS_DET_TL s
    set     estado = 'GD'
    where   numero = vl_salida
    and     lo_codigo = vl_local
    and     exists (
                select  'x'
                from    BANDEJAS b, JSYB_RCM_REVISIONES_CONTENIDO r
                where   b.numero = s.numero
                and     b.lo_codigo = s.lo_codigo
                and     b.bdg_codigo = s.bdg_codigo
                and     r.codigo_bandeja = b.codigo_bandeja
            );
    
    update  BANDEJAS b
    set     estado = 'TR'
    where   numero = vl_salida
    and     lo_codigo = vl_local
    and     exists (
                select  'x'
                from    JSYB_RCM_REVISIONES_CONTENIDO r
                where   r.codigo_bandeja = b.codigo_bandeja
            );
    
    update  DETALLE_X_BANDEJAS
    set     estado_traspaso_pp = NULL,
            estado_traspaso_pt = NULL,
            estado_traspaso_td = NULL
    where   codigo_bandeja in (
                select  b.codigo_bandeja
                from    BANDEJAS b, JSYB_RCM_REVISIONES_CONTENIDO r
                where   b.numero = vl_salida
                and     b.lo_codigo = vl_local
                and     r.codigo_bandeja = b.codigo_bandeja
            );
    
    update  JSYB_RCM_BANDEJAS
    set     estado = 'PREV'
    where   codigo_empresa = vl_empresa
    and     numero_salida = vl_salida
    and     lo_codigo = vl_local
    and     estado in ( 'ERC', 'REV' );
    
    delete  JSYB_BG_MOVS_BANDEJA s
    where   codigo_bandeja in (
                select  b.codigo_bandeja
                from    BANDEJAS b, JSYB_RCM_REVISIONES_CONTENIDO r
                where   b.numero = vl_salida
                and     b.lo_codigo = vl_local
                and     r.codigo_bandeja = b.codigo_bandeja
            );
    
    update  DETALLE_X_BANDEJAS
    set     estado_traspaso_pp = null,
            estado_traspaso_pt = null,
            estado_traspaso_td = null
    where   codigo_bandeja in (
                select  b.codigo_bandeja
                from    BANDEJAS b, JSYB_RCM_REVISIONES_CONTENIDO r
                where   b.numero = vl_salida
                and     b.lo_codigo = vl_local
                and     r.codigo_bandeja = b.codigo_bandeja
            );
            
    delete  JSYB_RCM_DETALLE_REVISION
    where   codigo_empresa = vl_empresa
    and     numero_salida = vl_salida
    and     lo_codigo = vl_local;
    
    delete  JSYB_RCM_REVISIONES_CONTENIDO
    where   codigo_empresa = vl_empresa
    and     numero_salida = vl_salida
    and     lo_codigo = vl_local;
    
    update  JSYB_RCM_SALIDAS_PROC
    set     estado = 'RBC'
    where   codigo_empresa = vl_empresa
    and     numero_salida = vl_salida
    and     lo_codigo = vl_local;
    
    delete  DIFERENCIAS_ITEM_RECEPCION
    where   ba_codigo_bandeja in (
                select  b.codigo_bandeja
                from    BANDEJAS b
                where   numero = vl_salida
                and     lo_codigo = vl_local
            );
    
    commit;
end;