CREATE OR REPLACE PROCEDURE RRP_MDL."ETL_INIT_O_IOL_WIND_CBONDDESCRIPTION" (I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 中国债券基本资料
  **存储过程名称：    ETL_INIT_O_IOL_WIND_CBONDDESCRIPTION
  **存储过程创建日期：20221129
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  ********************************************************************/
 AS
  -- 定义变量 --

  V_STEP      INTEGER := '0'; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_WIND_CBONDDESCRIPTION'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_DATE DATE;
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  V_MONTH_START_DATE:=TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM');


  --将参数转化为日期格式，判读输入参数是否符合日期要求
  V_DATE    := TO_DATE(I_P_DATE,'YYYY-MM-DD');

  --清理当天数据
  -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IOL_WIND_CBONDDESCRIPTION';

 INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_WIND_CBONDDESCRIPTION NOLOGGING
    (
      OBJECT_ID  --对象ID
     ,S_INFO_WINDCODE  --WIND代码
     ,B_INFO_FULLNAME  --债券名称
     ,B_INFO_ISSUER  --发行人
     ,B_ISSUE_ANNOUNCEMENT  --发行公告日
     ,B_ISSUE_FIRSTISSUE  --发行起始日
     ,B_ISSUE_LASTISSUE  --发行截止日
     ,B_ISSUE_AMOUNTPLAN  --  计划发行总量(亿元)
     ,B_ISSUE_AMOUNTACT  --  实际发行总量(亿元)
     ,B_INFO_ISSUEPRICE  --发行价格
     ,B_INFO_PAR  --面值
     ,B_INFO_COUPONRATE  --发行票面利率(%)
     ,B_INFO_SPREAD  --利差(%)
     ,B_INFO_CARRYDATE  --计息起始日
     ,B_INFO_ENDDATE  --计息截止日
     ,B_INFO_MATURITYDATE  --到期日
     ,B_INFO_TERM_YEAR_  --债券期限(年)
     ,B_INFO_TERM_DAY_    --债券期限(天)
     ,B_INFO_PAYMENTDATE  --兑付日
     ,B_INFO_PAYMENTTYPE  --计息方式
     ,B_INFO_INTERESTFREQUENCY  --付息频率
     ,B_INFO_FORM  --债券形式
     ,B_INFO_COUPON  --息票品种
     ,B_INFO_INTERESTTYPE  --附息利率品种
     ,B_INFO_ACT  --特殊年计息天数
     ,B_ISSUE_FEE  --发行手续费率(%)
     ,B_REDEMPTION_FEERATION  --兑付手续费率(%)
     ,B_INFO_TAXRATE  --所得税率
     ,CRNCY_CODE  --货币代码
     ,S_INFO_NAME  --债券简称
     ,S_INFO_EXCHMARKET  --交易所
     ,B_INFO_GUARANTOR  --担保人
     ,B_INFO_GUARTYPE  --担保方式
     ,B_INFO_LISTDATE  --上市日期
     ,B_INFO_YEARSNUMBER  --年内序号
     ,S_DIV_RECORDDATE  --兑付登记起始日
     ,B_INFO_CODEBYPLACING  --上网发行认购代码
     ,B_INFO_DELISTDATE  --退市日期
     ,B_INFO_ISSUETYPE  --发行方式
     ,B_INFO_GUARINTRODUCTION  --担保简介
     ,B_INFO_BGNDBYPLACING  --上网发行起始日期
     ,B_INFO_ENDDBYPLACING  --上网发行截止日期
     ,B_INFO_AMOUNTBYPLACING  --上网发行数量(亿元)
     ,B_INFO_UNDERWRITINGCODE  --承销方式代码
     ,B_INFO_ISSUERCODE  --发行人编号
     ,B_INFO_FORMERCODE  --原债券代码
     ,B_INFO_COUPONTXT  --利率说明
     ,IS_FAILURE  --是否发行失败
     ,IS_CROSSMARKET  --是否跨市场
     ,B_INFO_COUPONDATETXT  --付息日说明
     ,B_INFO_SUBORDINATEORNOT  --是否次级债或混合资本债
     ,B_TENDRST_REFERYIELD  --参考收益率
     ,B_INFO_CURPAR  --最新面值
     ,S_INFO_FORMERWINDCODE  --原WIND代码
     ,IS_CORPORATE_BOND  --是否公司债
     ,B_INFO_ISSUERTYPE  --发行人类型
     ,B_INFO_SPECIALBONDTYPE  --特殊债券类型
     ,IS_PAYADVANCED  --是否可提前兑付
     ,IS_CALLABLE  --是否可赎回
     ,IS_CHOOSERIGHT  --是否有选择权
     ,IS_NETPRICE  --是否净价
     ,IS_ACT_DAYS  --是否按实际天数计息
     ,IS_INCBONDS  --是否增发债
     ,ISSUE_OBJECT  --发行对象
     ,B_INFO_ACTUALBENCHMARK  --计息基准
     ,REGISTER_FILE_TYPE_CODE  --注册文件类型代码
     ,REGISTER_FILE_NUMBER  --注册文件号
     ,LIST_ANN_DATE  --上市公告日
     ,START_DT  --开始日期
     ,END_DT  --结束日期
     ,ID_MARK  --增删标志
     ,ETL_TIMESTAMP
    )
  SELECT /*+PARALLEL*/
      OBJECT_ID  --对象ID
     ,S_INFO_WINDCODE  --WIND代码
     ,B_INFO_FULLNAME  --债券名称
     ,B_INFO_ISSUER  --发行人
     ,B_ISSUE_ANNOUNCEMENT  --发行公告日
     ,B_ISSUE_FIRSTISSUE  --发行起始日
     ,B_ISSUE_LASTISSUE  --发行截止日
     ,B_ISSUE_AMOUNTPLAN  --  计划发行总量(亿元)
     ,B_ISSUE_AMOUNTACT  --  实际发行总量(亿元)
     ,B_INFO_ISSUEPRICE  --发行价格
     ,B_INFO_PAR  --面值
     ,B_INFO_COUPONRATE  --发行票面利率(%)
     ,B_INFO_SPREAD  --利差(%)
     ,B_INFO_CARRYDATE  --计息起始日
     ,B_INFO_ENDDATE  --计息截止日
     ,B_INFO_MATURITYDATE  --到期日
     ,B_INFO_TERM_YEAR_  --债券期限(年)
     ,B_INFO_TERM_DAY_    --债券期限(天)
     ,B_INFO_PAYMENTDATE  --兑付日
     ,B_INFO_PAYMENTTYPE  --计息方式
     ,B_INFO_INTERESTFREQUENCY  --付息频率
     ,B_INFO_FORM  --债券形式
     ,B_INFO_COUPON  --息票品种
     ,B_INFO_INTERESTTYPE  --附息利率品种
     ,B_INFO_ACT  --特殊年计息天数
     ,B_ISSUE_FEE  --发行手续费率(%)
     ,B_REDEMPTION_FEERATION  --兑付手续费率(%)
     ,B_INFO_TAXRATE  --所得税率
     ,CRNCY_CODE  --货币代码
     ,S_INFO_NAME  --债券简称
     ,S_INFO_EXCHMARKET  --交易所
     ,B_INFO_GUARANTOR  --担保人
     ,B_INFO_GUARTYPE  --担保方式
     ,B_INFO_LISTDATE  --上市日期
     ,B_INFO_YEARSNUMBER  --年内序号
     ,S_DIV_RECORDDATE  --兑付登记起始日
     ,B_INFO_CODEBYPLACING  --上网发行认购代码
     ,B_INFO_DELISTDATE  --退市日期
     ,B_INFO_ISSUETYPE  --发行方式
     ,B_INFO_GUARINTRODUCTION  --担保简介
     ,B_INFO_BGNDBYPLACING  --上网发行起始日期
     ,B_INFO_ENDDBYPLACING  --上网发行截止日期
     ,B_INFO_AMOUNTBYPLACING  --上网发行数量(亿元)
     ,B_INFO_UNDERWRITINGCODE  --承销方式代码
     ,B_INFO_ISSUERCODE  --发行人编号
     ,B_INFO_FORMERCODE  --原债券代码
     ,B_INFO_COUPONTXT  --利率说明
     ,IS_FAILURE  --是否发行失败
     ,IS_CROSSMARKET  --是否跨市场
     ,B_INFO_COUPONDATETXT  --付息日说明
     ,B_INFO_SUBORDINATEORNOT  --是否次级债或混合资本债
     ,B_TENDRST_REFERYIELD  --参考收益率
     ,B_INFO_CURPAR  --最新面值
     ,S_INFO_FORMERWINDCODE  --原WIND代码
     ,IS_CORPORATE_BOND  --是否公司债
     ,B_INFO_ISSUERTYPE  --发行人类型
     ,B_INFO_SPECIALBONDTYPE  --特殊债券类型
     ,IS_PAYADVANCED  --是否可提前兑付
     ,IS_CALLABLE  --是否可赎回
     ,IS_CHOOSERIGHT  --是否有选择权
     ,IS_NETPRICE  --是否净价
     ,IS_ACT_DAYS  --是否按实际天数计息
     ,IS_INCBONDS  --是否增发债
     ,ISSUE_OBJECT  --发行对象
     ,B_INFO_ACTUALBENCHMARK  --计息基准
     ,REGISTER_FILE_TYPE_CODE  --注册文件类型代码
     ,REGISTER_FILE_NUMBER  --注册文件号
     ,LIST_ANN_DATE  --上市公告日
     ,START_DT  --开始日期
     ,END_DT  --结束日期
     ,ID_MARK  --增删标志
     ,ETL_TIMESTAMP
    FROM IOL.V_WIND_CBONDDESCRIPTION   中国债券基本资料--视图

   ;
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


END ETL_INIT_O_IOL_WIND_CBONDDESCRIPTION;
/

