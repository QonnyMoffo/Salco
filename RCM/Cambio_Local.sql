exec jsyb_fnd_funciones.JSYB_FND_SET_EMPRESA( 1 );


select  * from JSYB_RCM_CONEXIONES;

select  estado, ind_revision_rcm, codigo_bandeja, bdg_codigo,
                        decode(ind_revision_rcm, 'S', 'PREV', 'DIS') estado_ban, numero, lo_codigo
                from    BANDEJAS
                where   numero = 131615
                    and lo_codigo = 914;


--
--  Cambio de Local
--

select  *
from    salidas_det
where   numero = 131615
and     lo_codigo = :par_local_antiguo;

update  salidas_det
set     lo_codigo = :par_local_nuevo
where   numero = 131615
and     lo_codigo = :par_local_antiguo;

update  bandejas
set     lo_codigo = :par_local_nuevo
where   numero = 131615
and     lo_codigo = :par_local_antiguo;

commit;
