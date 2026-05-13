CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_DEPT_REPLACEMENT_INFO(I_P_DATE  IN  INTEGER, --跑批日期
                                                    O_ERRCODE OUT VARCHAR2 --错误代码
                                                   )
 /*******************************************************************
  **存储过程详细说明： 非同业单位贷款置换旧债表
  **存储过程名称：    ETL_O_IOL_ICMS_DEPT_REPLACEMENT_INFO
  **存储过程创建日期：20240401
  **存储过程创建人：  LYH
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250106    YJY        优化脚本
  ******************************************************************/
   AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_DEPT_REPLACEMENT_INFO'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE   := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE  := '0';
  
  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_CTMS_VI_TBS_ACCOUNT_CPTYS_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_DEPT_REPLACEMENT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-非同业单位贷款置换旧债表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_DEPT_REPLACEMENT_INFO NOLOGGING
    (
     SERIALNO         --01 流水号
    ,PUTOUTSERIALNO   --02 出账流水号
    ,DEPTORNAME       --03 被置换贷款借款人名称
    ,BANKNAME         --04 被置换贷款发放行名称
    ,DEPTTYPE         --05 被置换债务类型
    ,CERTTYPE         --06 被置换债务债权人证件类型
    ,CERTID           --07 被置换债务债权人证件代码
    ,PLATFORMLOAN     --08 是否置换地方政府融资平台债务
    ,DEPTTOKEN        --09 被置换债务凭证编码
    ,CURRENCY         --10 被置换债务币种
    ,RMBAMOUNT        --11 被置换债务金额折人民币
    ,EXECUTERATE      --12 被置换债务利率水平
    ,INPUTUSERID      --13 登记人
    ,INPUTORGID       --14 登记机构
    ,INPUTDATE        --15 登记日期
    ,UPDATEUSERID     --16 更新人
    ,UPDATEORGID      --17 更新机构
    ,UPDATEDATE       --18 更新日期
    ,START_DT         --19 开始时间
    ,END_DT           --20 结束时间
    ,ID_MARK          --21 增删标志
    ,ETL_TIMESTAMP    --22 ETL处理时间戳
    )
  SELECT /*+PARALLEL*/
         SERIALNO         --01 流水号
        ,PUTOUTSERIALNO   --02 出账流水号
        ,DEPTORNAME       --03 被置换贷款借款人名称
        ,BANKNAME         --04 被置换贷款发放行名称
        ,DEPTTYPE         --05 被置换债务类型
        ,CERTTYPE         --06 被置换债务债权人证件类型
        ,CERTID           --07 被置换债务债权人证件代码
        ,PLATFORMLOAN     --08 是否置换地方政府融资平台债务
        ,DEPTTOKEN        --09 被置换债务凭证编码
        ,CURRENCY         --10 被置换债务币种
        ,RMBAMOUNT        --11 被置换债务金额折人民币
        ,EXECUTERATE      --12 被置换债务利率水平
        ,INPUTUSERID      --13 登记人
        ,INPUTORGID       --14 登记机构
        ,INPUTDATE        --15 登记日期
        ,UPDATEUSERID     --16 更新人
        ,UPDATEORGID      --17 更新机构
        ,UPDATEDATE       --18 更新日期
        ,START_DT         --19 开始时间
        ,END_DT           --20 结束时间
        ,ID_MARK          --21 增删标志
        ,ETL_TIMESTAMP    --22 ETL处理时间戳
    FROM IOL.V_ICMS_DEPT_REPLACEMENT_INFO  --视图_非同业单位贷款置换旧债表
    WHERE ID_MARK <> 'D';
    
    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
    
  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

END ETL_O_IOL_ICMS_DEPT_REPLACEMENT_INFO;
/

