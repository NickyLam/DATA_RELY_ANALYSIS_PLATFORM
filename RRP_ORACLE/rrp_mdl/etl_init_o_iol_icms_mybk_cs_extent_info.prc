CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_ICMS_MYBK_CS_EXTENT_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_ICMS_MYBK_CS_EXTENT_INFO
  *  功能描述：网商贷初审扩展信息
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_ICMS_MYBK_CS_EXTENT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_ICMS_MYBK_CS_EXTENT_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

 --清理当天数据
  V_STEP_DESC  := '清理当天数据';
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_MYBK_CS_EXTENT_INFO';

  V_STEP_DESC  := '装入目标表';
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_MYBK_CS_EXTENT_INFO NOLOGGING
    (
						SERNO  --流水号
						,REGISTERADDRESSAREA  --注册地省市区
						,STATUSID  --经营状态
						,SEX  --性别
						,CITY  --城市
						,REGISTERNO  --工商注册号
						,ORGCODE  --组织机构号
						,MANAGEBEGINDATE  --经营开始时间
						,OPENDATE  --开业时间
						,ECONOMICTYPE  --公司经济类型
						,REGISTERADDRESSAREACODE  --注册地址行政区编号
						,AREA  --地区
						,COMPANYTYPE  --公司类型
						,REGISTERDATE  --注册时间
						,INDUSTRYNAME  --客群主营行业
						,NATIONALITY  --国籍
						,REGISTERADDRESS  --注册地址
						,REGISTERDEPARTMENT  --注册工商局
						,MIGTFLAG  --迁移标志：CRSRCRILCUPL
						,BUSDATAREQDATE  --采集时间
						,BUSINFOEXISTFLAG  --是否存有效商信息
						,FUNDCURRENCY  --币种
						,COMPANYINFONAME  --公司名
						,TRADECODE  --行业代码
						,MANAGERANGE  --经营范围
						,MOBILE  --手机号码
						,CERTVALIDENDDATE  --证件有效期
						,STATUSDESC  --经营状态描述
						,CERTVALIDSTARTDATE  --证件有效期起始日
						,MANAGEENDDATE  --经营结束时间
						,TARGETJYFLAG1  --客群经营标签（经营场景)
						,APPLYNO  --蚂蚁申请编号
						,COMPANYINFOLAWER  --法定代表
						,REGISTERFUND  --注册资本(万元)
						,ADDRESS  --地址信息
						,PROV  --省份
						,NOTEXISTREASON  --无有效工商信息原因
						,LASTCHECKYEAR  --最后年检年度
						,INDIVOCC  --职业
						,ETL_DT  --ETL处理日期
						,ETL_TIMESTAMP  --ETL处理时间戳

     )
  SELECT /*+PARALLEL*/
						SERNO  --流水号
						,REGISTERADDRESSAREA  --注册地省市区
						,STATUSID  --经营状态
						,SEX  --性别
						,CITY  --城市
						,REGISTERNO  --工商注册号
						,ORGCODE  --组织机构号
						,MANAGEBEGINDATE  --经营开始时间
						,OPENDATE  --开业时间
						,ECONOMICTYPE  --公司经济类型
						,REGISTERADDRESSAREACODE  --注册地址行政区编号
						,AREA  --地区
						,COMPANYTYPE  --公司类型
						,REGISTERDATE  --注册时间
						,INDUSTRYNAME  --客群主营行业
						,NATIONALITY  --国籍
						,REGISTERADDRESS  --注册地址
						,REGISTERDEPARTMENT  --注册工商局
						,MIGTFLAG  --迁移标志：CRSRCRILCUPL
						,BUSDATAREQDATE  --采集时间
						,BUSINFOEXISTFLAG  --是否存有效商信息
						,FUNDCURRENCY  --币种
						,COMPANYINFONAME  --公司名
						,TRADECODE  --行业代码
						,MANAGERANGE  --经营范围
						,MOBILE  --手机号码
						,CERTVALIDENDDATE  --证件有效期
						,STATUSDESC  --经营状态描述
						,CERTVALIDSTARTDATE  --证件有效期起始日
						,MANAGEENDDATE  --经营结束时间
						,TARGETJYFLAG1  --客群经营标签（经营场景)
						,APPLYNO  --蚂蚁申请编号
						,COMPANYINFOLAWER  --法定代表
						,REGISTERFUND  --注册资本(万元)
						,ADDRESS  --地址信息
						,PROV  --省份
						,NOTEXISTREASON  --无有效工商信息原因
						,LASTCHECKYEAR  --最后年检年度
						,INDIVOCC  --职业
						,ETL_DT + 1  --ETL处理日期
						,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IOL.V_ICMS_MYBK_CS_EXTENT_INFO   --主指令表(视图)_视图
  ;

 V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   --插入跑批完成记录--
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
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

  END ETL_INIT_O_IOL_ICMS_MYBK_CS_EXTENT_INFO;
/

