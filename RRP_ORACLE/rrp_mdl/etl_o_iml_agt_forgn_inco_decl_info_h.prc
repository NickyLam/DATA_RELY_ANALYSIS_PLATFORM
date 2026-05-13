CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_FORGN_INCO_DECL_INFO_H(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：涉外收入申报信息历史
  **存储过程名称：    ETL_O_IML_AGT_FORGN_INCO_DECL_INFO_H
  **存储过程创建日期：20250121
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250121    YJY        创建
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_AGT_FORGN_INCO_DECL_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_FORGN_INCO_DECL_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-涉外收入申报信息历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_FORGN_INCO_DECL_INFO_H NOLOGGING 
  (         AGT_ID                    --协议编号
           ,LP_ID                     --法人编号
           ,DECL_ID                   --申报编号
           ,TEMP_DECL_FLOW_ID         --临时申报流水编号
           ,INIT_ENTY_ID              --原始实体编号
           ,OPER_TYPE_CD              --操作类型代码
           ,MODIF_RS_COMNT            --变更原因说明
           ,DECL_NUM                  --申报号码
           ,PAYER_PERMT_CTY_RG_CD     --付款人常驻国家和地区代码
           ,BUS_ID                    --业务编号
           ,INCO_TYPE_CD              --收入类型代码
           ,RECVBL_CHAR_CD            --收款性质代码
           ,TRAN_ID_1                 --交易编号1
           ,TRAN_AMT_1                --交易金额1
           ,TRAN_POSTSC_1             --交易附言1
           ,TRAN_ID_2                 --交易编号2
           ,TRAN_AMT_2                --交易金额2
           ,TRAN_POSTSC_2             --交易附言2
           ,UNBOND_CARGO_INCO_FLG     --保税货物项下收入标志
           ,DECL_PS_NAME              --申报人名称
           ,DECL_PS_TEL_NUM           --申报人电话号码
           ,DECL_DT                   --申报日期
           ,START_DT                  --开始时间
           ,END_DT                    --结束时间
           ,ID_MARK                   --增删标志
           ,SRC_TABLE_NAME            --源表名称
           ,JOB_CD                    --任务编码
           ,ETL_TIMESTAMP             --ETL处理时间戳
    )
    SELECT
            AGT_ID                    --协议编号
           ,LP_ID                     --法人编号
           ,DECL_ID                   --申报编号
           ,TEMP_DECL_FLOW_ID         --临时申报流水编号
           ,INIT_ENTY_ID              --原始实体编号
           ,OPER_TYPE_CD              --操作类型代码
           ,MODIF_RS_COMNT            --变更原因说明
           ,DECL_NUM                  --申报号码
           ,PAYER_PERMT_CTY_RG_CD     --付款人常驻国家和地区代码
           ,BUS_ID                    --业务编号
           ,INCO_TYPE_CD              --收入类型代码
           ,RECVBL_CHAR_CD            --收款性质代码
           ,TRAN_ID_1                 --交易编号1
           ,TRAN_AMT_1                --交易金额1
           ,TRAN_POSTSC_1             --交易附言1
           ,TRAN_ID_2                 --交易编号2
           ,TRAN_AMT_2                --交易金额2
           ,TRAN_POSTSC_2             --交易附言2
           ,UNBOND_CARGO_INCO_FLG     --保税货物项下收入标志
           ,DECL_PS_NAME              --申报人名称
           ,DECL_PS_TEL_NUM           --申报人电话号码
           ,DECL_DT                   --申报日期
           ,START_DT                  --开始时间
           ,END_DT                    --结束时间
           ,ID_MARK                   --增删标志
           ,SRC_TABLE_NAME            --源表名称
           ,JOB_CD                    --任务编码
           ,ETL_TIMESTAMP             --ETL处理时间戳
  FROM IML.V_AGT_FORGN_INCO_DECL_INFO_H  --视图-涉外收入申报信息历史
 WHERE ID_MARK <> 'D'
   AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_FORGN_INCO_DECL_INFO_H', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_AGT_FORGN_INCO_DECL_INFO_H;
/

