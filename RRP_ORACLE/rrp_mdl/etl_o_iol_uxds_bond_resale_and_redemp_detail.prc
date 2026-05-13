CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_UXDS_BOND_RESALE_AND_REDEMP_DETAIL(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：中国债券回售赎回条款明细
  **存储过程名称：    ETL_O_IOL_UXDS_BOND_RESALE_AND_REDEMP_DETAIL
  **存储过程创建日期：20250919
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250919    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_UXDS_BOND_RESALE_AND_REDEMP_DETAIL'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_UXDS_BOND_RESALE_AND_REDEMP_DETAIL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-中国债券回售赎回条款明细';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_UXDS_BOND_RESALE_AND_REDEMP_DETAIL NOLOGGING 
  (          SEQ                    --记录唯一标识
            ,CTIME                  --记录创建日期
            ,MTIME                  --记录修改日期
            ,RTIME                  --记录通讯到用户端日期
            ,BOND_ID                --债券id
            ,BOND_SHORT_NAME        --债券简称
            ,CLAUSE_TYPE_CODE       --条款类型编码
            ,CLAUSE_TYPE            --条款类型
            ,FORE_OCCURRENCE_DATE   --预计发生日期
            ,PRICE                  --价格
            ,NOTICE_ED              --告知截止日
            ,IS_SURE_TO_EXERCISE    --是否确定行权
            ,IS_ACTUALLY_EXERCISED  --实际是否行权
            ,PAR_VALUE              --面值
            ,INTEREST_RATE          --利息
            ,PRICE_SPE_INS          --价格特殊说明
            ,ISVALID                --是否有效
            ,START_DT               --开始时间
            ,END_DT                 --结束时间
            ,ID_MARK                --增删标志
            ,ETL_TIMESTAMP          --ETL处理时间戳
    )
    SELECT
             SEQ                    --记录唯一标识
            ,CTIME                  --记录创建日期
            ,MTIME                  --记录修改日期
            ,RTIME                  --记录通讯到用户端日期
            ,BOND_ID                --债券id
            ,BOND_SHORT_NAME        --债券简称
            ,CLAUSE_TYPE_CODE       --条款类型编码
            ,CLAUSE_TYPE            --条款类型
            ,FORE_OCCURRENCE_DATE   --预计发生日期
            ,PRICE                  --价格
            ,NOTICE_ED              --告知截止日
            ,IS_SURE_TO_EXERCISE    --是否确定行权
            ,IS_ACTUALLY_EXERCISED  --实际是否行权
            ,PAR_VALUE              --面值
            ,INTEREST_RATE          --利息
            ,PRICE_SPE_INS          --价格特殊说明
            ,ISVALID                --是否有效
            ,START_DT               --开始时间
            ,END_DT                 --结束时间
            ,ID_MARK                --增删标志
            ,ETL_TIMESTAMP          --ETL处理时间戳
  FROM IOL.V_UXDS_BOND_RESALE_AND_REDEMP_DETAIL --视图-中国债券回售赎回条款明细
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_UXDS_BOND_RESALE_AND_REDEMP_DETAIL', '', O_ERRCODE);

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

END ETL_O_IOL_UXDS_BOND_RESALE_AND_REDEMP_DETAIL;
/

