CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ISBS_PTE(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：表外信息
  **存储过程名称：    ETL_O_IOL_ISBS_PTE
  **存储过程创建日期：20251015
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251015    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ISBS_PTE'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ISBS_PTE';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-表外信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ISBS_PTE NOLOGGING 
  (           INR              --内部唯一ID号
             ,OBJTYP           --关联PTS的类型
             ,OBJINR           --关联PTS的INR
             ,SUBID            --标识PTS的多个PTE
             ,CBTPFX           --表外风险类型
             ,GRPKEY           --责任组
             ,EXTID            --关联实体CBS
             ,LIAPTYINR        --记账用户的PTY的唯一INR
             ,LIAPTAINR        --记账用户的PTA的唯一INR
             ,CDTPTSINR        --贷方INR
             ,OWNREF           --参考号
             ,NAM              --帐务信息
             ,FEEINR           --费用INR
             ,BEGDAT           --开始日期
             ,CLSDAT           --关闭日期
             ,SETDAT           --结束日期
             ,NXTCOMDAT        --下次费用计算时间
             ,ROLPAY           --付费角色
             ,MATDAT           --到期日
             ,COVTYP           --结帐类型
             ,PRC              --分配百分比
             ,AMTFLG           --记账方式
             ,VER              --版本号
             ,ASGTXT           --代理人信息
             ,ASBTXT           --代理银行信息
             ,TENDAY           --最大到期日
             ,START_DT         --开始时间
             ,END_DT           --结束时间
             ,ID_MARK          --增删标志
             ,ETL_TIMESTAMP    --ETL处理时间戳
    )
    SELECT
              INR              --内部唯一ID号
             ,OBJTYP           --关联PTS的类型
             ,OBJINR           --关联PTS的INR
             ,SUBID            --标识PTS的多个PTE
             ,CBTPFX           --表外风险类型
             ,GRPKEY           --责任组
             ,EXTID            --关联实体CBS
             ,LIAPTYINR        --记账用户的PTY的唯一INR
             ,LIAPTAINR        --记账用户的PTA的唯一INR
             ,CDTPTSINR        --贷方INR
             ,OWNREF           --参考号
             ,NAM              --帐务信息
             ,FEEINR           --费用INR
             ,BEGDAT           --开始日期
             ,CLSDAT           --关闭日期
             ,SETDAT           --结束日期
             ,NXTCOMDAT        --下次费用计算时间
             ,ROLPAY           --付费角色
             ,MATDAT           --到期日
             ,COVTYP           --结帐类型
             ,PRC              --分配百分比
             ,AMTFLG           --记账方式
             ,VER              --版本号
             ,ASGTXT           --代理人信息
             ,ASBTXT           --代理银行信息
             ,TENDAY           --最大到期日
             ,START_DT         --开始时间
             ,END_DT           --结束时间
             ,ID_MARK          --增删标志
             ,ETL_TIMESTAMP    --ETL处理时间戳
  FROM IOL.V_ISBS_PTE --视图-表外信息
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ISBS_PTE', '', O_ERRCODE);

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

END ETL_O_IOL_ISBS_PTE;
/

