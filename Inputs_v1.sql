
/********************************************************
   ---|>         BASE DE VENTA QUE HACE CDP     <|----
*********************************************************/        

SELECT   A.VCHPERIODO PERIODOVENTA, 
         A.VCHN_PLAN,
         A.VCHTERMINAL_TIPOEQUIPO,
         VCHTIPO,
         A.VCHPACK_SIM_SIMPLE,
         b.NUMPERIODO_EJEC VCHPERIODOEJECUCION_CP, 
         B.NUMFLG_PERFILADO,
         A.VCHVEP_FLAG_TOTAL,
         sum(A.NUMGROSS)NUMGROSS,
         sum(NUMRENTASINIGV_ORIG)NUMRENTASINIGV_ORIG, 
         sum(NUMRENTASINIGV_DEST) NUMRENTASINIGV_DEST, 
         sum(NUMGAPSINIGV_TOTAL) NUMGAPSINIGV_TOTAL
FROM INAR_TOTAL A 
LEFT JOIN hom_cambioplan_rprt B
        ON A.NUMCODIGOCONTRATOBSCS = b.NUMCODIGOCONTRATOBSCS
        AND A.VCHPERIODO <= b.NUMPERIODO_EJEC
        AND B.VCHPLANTARIFARIO_ORIG NOT LIKE B.VCHPLANTARIFARIO_DEST 
        AND NUMFLG_INTERNET = '0'
        AND NUMFLG_PREPAGO = '0'
  GROUP BY A.VCHPERIODO, 
         A.VCHN_PLAN,
         B.NUMFLG_PERFILADO,
         A.VCHTERMINAL_TIPOEQUIPO,
         A.VCHPACK_SIM_SIMPLE,  
         VCHTIPO,
         A.VCHVEP_FLAG_TOTAL,
         NUMPERIODO_EJEC

/********************************************************
   ---|>         BASE DE VENTA QUE RENUEVA    <|----
*********************************************************/  

SELECT  A.VCHPERIODO PERIODOVENTA,
        A.VCHFECHAPROCESO,
        A.VCHN_PLAN,      
        B.NUMPERIODO PERIODORENOV,
        B.VCHTIPO_PRODUCTO_ORIG,
        B.VCHTIPO,
        B.VCHFLAG_VEP FLAG_VEP, 
        SUM(B.NUMCUOTA_VEP) NUMVALOR_CUOTA,
        b.numflg_perfilado FLAG_PERFILADA,
        SUM(A.NUMGROSS)NUMGROSS,
        SUM(B.NUMRENTABASICA_ORIG)NUMRENTABASICA_ORIG,
        SUM(B.NUMRENTABASICA_DEST)NUMRENTABASICA_DEST,
        SUM(B.NUMGAP_CDP) SUM_NUMRENTA_DIF
FROM INAR_TOTAL A 
LEFT JOIN hom_renovacionequipo_rprt B 
    ON A.NUMCODIGOCONTRATOBSCS = b.NUMCODIGOCONTRATOBSCS
    AND A.VCHPERIODO <= B.NUMPERIODO
    AND b.vchflag_fechas = 'NO'
group by A.VCHPERIODO,
         A.VCHFECHAPROCESO, 
         A.VCHN_PLAN,        
         B.NUMPERIODO,
         B.VCHTIPO_PRODUCTO_ORIG,
         B.VCHTIPO,
         B.VCHFLAG_VEP,
         numflg_perfilado
;


-- 3a. Base_Ventas_Desactivaciones (NUEVO QUERY SIN PERFILAMIENTO // LISTO DNI + RUC 10)

-- QUITAR AVG, SOLO SUM
-- AÑADIR CAMPO DE PACK_SIM_SIMPLE_MANDATO
   
/********************************************************
   ---|>         BASE DE VENTA QUE HACE DEAC    <|----
*********************************************************/  


SELECT  A.VCHPERIODO PERIODOVENTA,
        a.vchtelefono,
        A.VCHN_PLAN,
        A.VCHMODOPAGO,
        A.VCHTERMINAL_TIPOEQUIPO,
        B.VCHPERIODO PERIODODEAC,
        B.VCHTIPO_CHURN,
        a.numvep_pago_cuota,
        a.vchvep_flag_total,
        SUM(a.numgross)numgross,
        SUM(a.numcargofijo)numcargofijo
FROM INAR_TOTAL A 
LEFT JOIN DEACS_TOTAL B
    ON A.NUMCODIGOCONTRATOBSCS = B.VCHC_CONTRATO 
    AND A.VCHPERIODO <= B.VCHPERIODO
GROUP BY A.VCHPERIODO,
         a.vchtelefono,
        A.VCHN_PLAN,
        A.VCHMODOPAGO,
        A.VCHTERMINAL_TIPOEQUIPO,
        B.VCHPERIODO,
        B.VCHTIPO_CHURN,
        a.numvep_pago_cuota,
        a.vchvep_flag_total
;
