CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_WLD_IQP_LOAN_APP (I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 微粒贷授信表
  **存储过程名称：    ETL_O_IOL_ICMS_WLD_IQP_LOAN_APP
  **存储过程创建日期：20240205
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  **  20240205   hulj       首次创建
  *   20250106   YJY        优化脚本
  *******************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_WLD_IQP_LOAN_APP'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_WLD_IQP_LOAN_APP';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  
  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-微粒贷授信表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_WLD_IQP_LOAN_APP NOLOGGING
    (
           SERIALNO               --授信流水号
          ,SEQNO                  --业务流水号
          ,TRANSCODE              --交易场景
          ,PRODUCTTYPE            --产品类型
          ,WLDVERSION             --版本号
          ,WLDTIMESTAMP           --时间戳
          ,BANKNO                 --银行号
          ,PAPPORDERID            --业务订单号
          ,BIZSCENE               --业务场景
          ,ISCUSTDATAQUERYAUTH    --客户是否授权查外部数据源
          ,ISNEEDTDOUTERDATA      --是否需要查询外部多头数据
          ,ISNEEDGAOUTERDATA      --是否需要查询外部公安数据
          ,ISNEEDHFOUTERDATA      --是否需要查询外部法诉数据
          ,ISNEEDYEOUTERDATA      --是否需要判断客户在合作行贷款余额超过20w
          ,ISNEEDXXOUTERDATA      --是否需要查询外部学位数据
          ,ISNEEDOUTERLIMIT       --是否加工合作机构可用额度
          ,ISNEEDOUTERLIST        --是否需要查询名单信息
          ,IDTYPE                 --证件类型(不建议)
          ,IDNO                   --证件号
          ,CERTTYPE               --证件类型(建议)
          ,CUSTOMERNAME           --姓名
          ,GENDERNO               --性别
          ,NATION                 --国籍
          ,VALIDBEGINTIME         --有效起始日
          ,VALIDENDTIME           --有效结束日
          ,PROFESSION             --职业
          ,ADDRESS                --地址
          ,PHONE                  --电话号
          ,ISHASLANDLINE          --是否有座机
          ,LIMITPURPOSE           --额度用途
          ,FIRSTCHECKLIMIT        --初审额度
          ,CALLBACKCODE           --回调接口号
          ,INPUTUSERID            --客户经理
          ,INPUTORGID             --所属机构
          ,INPUTDATE              --登记时间
          ,CUSTOMERID             --客户号
          ,OPENFLAG               --开户标识
          ,INFORMFLAG             --通知标识
          ,RISKPAPPORDERID        --业务订单号(风控)
          ,RISKTDOUTERDATA        --外部多头共债数据(风控)
          ,RISKGAOUTERDATA        --外部公安数据(风控)
          ,RISKHFOUTERDATA        --外部法诉数据(风控)
          ,RISKYEOUTERDATA        --客户在合作行贷款余额超过20w(风控)
          ,RISKXXOUTERDATA        --外部学位数据(风控)
          ,RISKNEGATIVE           --反洗钱名单(风控)
          ,RISKRELATIONAL         --关系人关联人名单(风控)
          ,RISKOTHERRULE          --其他不准入规则(风控)
          ,RISKISOVERLIMITHAT     --是否到达额度上限(风控)
          ,RISKOUTERLIMIT         --合作机构可用额度(风控)
          ,APPROVESTATUS          --审批状态
          ,REMARK                 --备注
          ,OPERATEORGID           --账务机构
          ,START_DT               --开始时间
          ,END_DT                 --结束时间
          ,ID_MARK                --增删标志
    )
  SELECT /*+PARALLEL*/
           SERIALNO               --授信流水号
          ,SEQNO                  --业务流水号
          ,TRANSCODE              --交易场景
          ,PRODUCTTYPE            --产品类型
          ,WLDVERSION             --版本号
          ,WLDTIMESTAMP           --时间戳
          ,BANKNO                 --银行号
          ,PAPPORDERID            --业务订单号
          ,BIZSCENE               --业务场景
          ,ISCUSTDATAQUERYAUTH    --客户是否授权查外部数据源
          ,ISNEEDTDOUTERDATA      --是否需要查询外部多头数据
          ,ISNEEDGAOUTERDATA      --是否需要查询外部公安数据
          ,ISNEEDHFOUTERDATA      --是否需要查询外部法诉数据
          ,ISNEEDYEOUTERDATA      --是否需要判断客户在合作行贷款余额超过20w
          ,ISNEEDXXOUTERDATA      --是否需要查询外部学位数据
          ,ISNEEDOUTERLIMIT       --是否加工合作机构可用额度
          ,ISNEEDOUTERLIST        --是否需要查询名单信息
          ,IDTYPE                 --证件类型(不建议)
          ,IDNO                   --证件号
          ,CERTTYPE               --证件类型(建议)
          ,CUSTOMERNAME           --姓名
          ,GENDERNO               --性别
          ,NATION                 --国籍
          ,VALIDBEGINTIME         --有效起始日
          ,VALIDENDTIME           --有效结束日
          ,PROFESSION             --职业
          ,ADDRESS                --地址
          ,PHONE                  --电话号
          ,ISHASLANDLINE          --是否有座机
          ,LIMITPURPOSE           --额度用途
          ,FIRSTCHECKLIMIT        --初审额度
          ,CALLBACKCODE           --回调接口号
          ,INPUTUSERID            --客户经理
          ,INPUTORGID             --所属机构
          ,INPUTDATE              --登记时间
          ,CUSTOMERID             --客户号
          ,OPENFLAG               --开户标识
          ,INFORMFLAG             --通知标识
          ,RISKPAPPORDERID        --业务订单号(风控)
          ,RISKTDOUTERDATA        --外部多头共债数据(风控)
          ,RISKGAOUTERDATA        --外部公安数据(风控)
          ,RISKHFOUTERDATA        --外部法诉数据(风控)
          ,RISKYEOUTERDATA        --客户在合作行贷款余额超过20w(风控)
          ,RISKXXOUTERDATA        --外部学位数据(风控)
          ,RISKNEGATIVE           --反洗钱名单(风控)
          ,RISKRELATIONAL         --关系人关联人名单(风控)
          ,RISKOTHERRULE          --其他不准入规则(风控)
          ,RISKISOVERLIMITHAT     --是否到达额度上限(风控)
          ,RISKOUTERLIMIT         --合作机构可用额度(风控)
          ,APPROVESTATUS          --审批状态
          ,REMARK                 --备注
          ,OPERATEORGID           --账务机构
          ,START_DT               --开始时间
          ,END_DT                 --结束时间
          ,ID_MARK                --增删标志
   FROM IOL.V_ICMS_WLD_IQP_LOAN_APP   --微粒贷授信表
  WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    AND ID_MARK <> 'D'
   ;
   
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


END ETL_O_IOL_ICMS_WLD_IQP_LOAN_APP;
/

