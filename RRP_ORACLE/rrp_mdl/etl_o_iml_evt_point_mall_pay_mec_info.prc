CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_POINT_MALL_PAY_MEC_INFO(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：积分商城订单商品信息
  **存储过程名称：    ETL_O_IML_EVT_POINT_MALL_PAY_MEC_INFO
  **存储过程创建日期：20251014
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251014    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_EVT_POINT_MALL_PAY_MEC_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_POINT_MALL_PAY_MEC_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-积分商城订单商品信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_EVT_POINT_MALL_PAY_MEC_INFO NOLOGGING 
  (           EVT_ID                       --事件编号
             ,LP_ID                        --法人编号
             ,MERCHD_SUB_INDENT_FLOW_NUM   --商品子订单流水号
             ,INDENT_FLOW_NUM              --订单流水号
             ,MODE_PAY_CD                  --支付方式代码
             ,PROVI_NAME                   --供应商名称
             ,MERCHD_ID                    --商品编号
             ,MERCHD_NAME                  --商品名称
             ,MERCHD_TOT_QTTY              --商品总数量
             ,MERCHD_DESCB                 --商品描述
             ,SINGLE_MERCHD_COMM_FEE       --单个商品手续费
             ,VALID_FLG                    --有效标志
             ,FINAL_UPDATE_DT              --最后更新日期
             ,CREATE_TELLER_ID             --创建柜员编号
             ,UPDATE_TELLER_ID             --更新柜员编号
             ,START_DT                     --开始时间
             ,END_DT                       --结束时间
             ,ID_MARK                      --增删标志
             ,SRC_TABLE_NAME               --源表名称
             ,JOB_CD                       --任务编码
             ,ETL_TIMESTAMP                --ETL处理时间戳
    )
    SELECT
              EVT_ID                       --事件编号
             ,LP_ID                        --法人编号
             ,MERCHD_SUB_INDENT_FLOW_NUM   --商品子订单流水号
             ,INDENT_FLOW_NUM              --订单流水号
             ,MODE_PAY_CD                  --支付方式代码
             ,PROVI_NAME                   --供应商名称
             ,MERCHD_ID                    --商品编号
             ,MERCHD_NAME                  --商品名称
             ,MERCHD_TOT_QTTY              --商品总数量
             ,MERCHD_DESCB                 --商品描述
             ,SINGLE_MERCHD_COMM_FEE       --单个商品手续费
             ,VALID_FLG                    --有效标志
             ,FINAL_UPDATE_DT              --最后更新日期
             ,CREATE_TELLER_ID             --创建柜员编号
             ,UPDATE_TELLER_ID             --更新柜员编号
             ,START_DT                     --开始时间
             ,END_DT                       --结束时间
             ,ID_MARK                      --增删标志
             ,SRC_TABLE_NAME               --源表名称
             ,JOB_CD                       --任务编码
             ,ETL_TIMESTAMP                --ETL处理时间戳
  FROM IML.V_EVT_POINT_MALL_PAY_MEC_INFO --视图-积分商城订单商品信息
 WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   AND ID_MARK <> 'D';
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_EVT_POINT_MALL_PAY_MEC_INFO', '', O_ERRCODE);

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

END ETL_O_IML_EVT_POINT_MALL_PAY_MEC_INFO;
/

