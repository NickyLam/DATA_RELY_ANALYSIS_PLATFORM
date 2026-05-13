CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TTRD_INSTITUTION(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_IBMS_TTRD_INSTITUTION
  *  功能描述：客户信息及机构表
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_IBMS_TTRD_INSTITUTION
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  *             2    20241227  YJY      优化脚本
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_TTRD_INSTITUTION'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

   -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_INSTITUTION';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-客户信息及机构表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_INSTITUTION NOLOGGING
    (  I_ID                   --机构ID
      ,ORG_ID                 --机构号
      ,I_NAME                 --公司名称
      ,I_FULLNAME             --公司全称
      ,I_ALIAS                --公司别名
      ,PY_CODE                --拼音码
      ,STATUS                 --状态 0 创建中 1 以启用 2 停用
      ,T_CODE                 --分类代码(对机构进行多级分类)
      ,P_TYPE                 --产品类型
      ,ONLINE_DATE            --成立日期
      ,I_BUSINESS_LICENSE     --营业执照
      ,I_LR_INST_CODE         --机构代码证
      ,I_FINANCIAL_LICENSE    --金融许可证
      ,CNAPS_CODE             --现代支付系统行号(本币)
      ,SWIFT_CODE             --现代支付系统行号(外币)
      ,UPDATE_USER            --更新用户
      ,UPDATE_DATE            --更新日期
      ,UPDATE_TIME            --更新时间
      ,BELONG_TO_AREA         --总行或总公司注册地
      ,PIPE_ID                --导入管道
      ,IMP_DATE               --导入日期
      ,CORE_SYS_CUSTOMER_CODE --核心客户号
      ,T_PATH                 --客户分类
      ,I_LEVEL                --机构层级
      ,EDIT_IID               --维护机构
      ,EDIT_INAME             --维护机构名称
      ,ISSUER_CODE            --发行代码
      ,CFETS_MEMBER_ID        --外汇交易中心会员号
      ,INST_CLASS             --客户类型
      ,MEMBER_ID              --中心会员ID
      ,IS_MARKET_MAKER        --1:做市商 0:非做市商
      ,REV_STATE              --是否生效
      ,EN_NAME                --英文简称
      ,EN_FULLNAME            --英文全称
      ,CFETS_ORG_CODE         --下行机构代码
      ,CREATE_USER            --创建用户
      ,ACCTG_I_ID             --记账机构
      ,IS_SPV                 --是否是SPV  0：非SPV（默认） 1: SPV
      ,RWA_CODE               --RWA客户分类代码
      ,RWA_NAME               --RWA客户分类名称
      ,SPV_MANAGER            --SPV管理人
      ,ADDRESS                --
      ,LEGAL_REPRESENTATIVE   --
      ,IS_TICKETINFO          --
      ,MAIN_PROTOCOL_CODE     --
      ,START_DT               --开始时间
      ,END_DT                 --结束时间
      ,ID_MARK                --增删标志
     )
  SELECT /*+PARALLEL*/
       I_ID                   --机构ID
      ,ORG_ID                 --机构号
      ,I_NAME                 --公司名称
      ,I_FULLNAME             --公司全称
      ,I_ALIAS                --公司别名
      ,PY_CODE                --拼音码
      ,STATUS                 --状态 0 创建中 1 以启用 2 停用
      ,T_CODE                 --分类代码(对机构进行多级分类)
      ,P_TYPE                 --产品类型
      ,ONLINE_DATE            --成立日期
      ,I_BUSINESS_LICENSE     --营业执照
      ,I_LR_INST_CODE         --机构代码证
      ,I_FINANCIAL_LICENSE    --金融许可证
      ,CNAPS_CODE             --现代支付系统行号(本币)
      ,SWIFT_CODE             --现代支付系统行号(外币)
      ,UPDATE_USER            --更新用户
      ,UPDATE_DATE            --更新日期
      ,UPDATE_TIME            --更新时间
      ,BELONG_TO_AREA         --总行或总公司注册地
      ,PIPE_ID                --导入管道
      ,IMP_DATE               --导入日期
      ,CORE_SYS_CUSTOMER_CODE --核心客户号
      ,T_PATH                 --客户分类
      ,I_LEVEL                --机构层级
      ,EDIT_IID               --维护机构
      ,EDIT_INAME             --维护机构名称
      ,ISSUER_CODE            --发行代码
      ,CFETS_MEMBER_ID        --外汇交易中心会员号
      ,INST_CLASS             --客户类型
      ,MEMBER_ID              --中心会员ID
      ,IS_MARKET_MAKER        --1:做市商 0:非做市商
      ,REV_STATE              --是否生效
      ,EN_NAME                --英文简称
      ,EN_FULLNAME            --英文全称
      ,CFETS_ORG_CODE         --下行机构代码
      ,CREATE_USER            --创建用户
      ,ACCTG_I_ID             --记账机构
      ,IS_SPV                 --是否是SPV  0：非SPV（默认） 1: SPV
      ,RWA_CODE               --RWA客户分类代码
      ,RWA_NAME               --RWA客户分类名称
      ,SPV_MANAGER            --SPV管理人
      ,ADDRESS                --
      ,LEGAL_REPRESENTATIVE   --
      ,IS_TICKETINFO          --
      ,MAIN_PROTOCOL_CODE     --
      ,START_DT               --开始时间
      ,END_DT                 --结束时间
      ,ID_MARK                --增删标志
    FROM IOL.V_IBMS_TTRD_INSTITUTION   --客户信息及机构表_视图
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

  END ETL_O_IOL_IBMS_TTRD_INSTITUTION;
/

