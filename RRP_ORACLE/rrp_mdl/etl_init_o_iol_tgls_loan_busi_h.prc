CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_TGLS_LOAN_BUSI_H(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_TGLS_LOAN_BUSI_H
  *  功能描述：通用交易明细流水归集表
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_TGLS_LOAN_BUSI_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_TGLS_LOAN_BUSI_H'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IOL_TGLS_LOAN_BUSI_H';

  V_STEP_DESC  := '装入目标表';
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_TGLS_LOAN_BUSI_H NOLOGGING
    (
					STACID  --账套
					,SYSTID  --交易来源系统编号
					,TRANDT  --交易日期
					,TRANSQ  --交易流水
					,BSNSSQ  --业务流水
					,TRANBR  --交易机构编号
					,ACCTBR  --贷款机构
					,PRCSCD  --处理码
					,PRODCD  --产品编号
					,LOANP1  --产品属性1
					,LOANP2  --产品属性2
					,LOANP3  --产品属性3
					,LOANP4  --产品属性4
					,LOANP5  --产品属性5
					,LOANP6  --产品属性6
					,LOANP7  --产品属性7
					,LOANP8  --产品属性8
					,LOANP9  --产品属性9
					,LOANPA  --产品属性10
					,TRANTP  --交易方式(TR:转账，CS:现金)
					,CRCYCD  --币种代码
					,CUSTCD  --客户编号
					,STATUS  --交易状态(0:未处理1：处理成功2：处理失败3：差错处理中4：差错处理完成)
					,SERINO  --序号
					,BATHID  --批次号
					,EVETDN  --交易方向ADD增加，MINUS减少
					,TRPRCD  --余额类型
					,TRANAM  --交易金额
					,CENTCD  --责任中心
					,PRSNCD  --员工编号
					,PRLNCD  --产品线
					,ACCTNO  --账户
					,ASSIS0  --辅助核算0（自定义）
          ,ASSIS1  --辅助核算1（自定义）
          ,ASSIS2  --辅助核算2（自定义）
          ,ASSIS3  --辅助核算3（自定义）
          ,ASSIS4  --辅助核算4（自定义）
          ,ASSIS5  --辅助核算5（自定义）
          ,ASSIS6  --辅助核算6（自定义）
          ,ASSIS7  --辅助核算7（自定义）
          ,ASSIS8  --辅助核算8（自定义）
          ,ASSIS9  --辅助核算9（自定义）
          ,NUMEX0  --金额1
          ,NUMEX1  --金额2
          ,NUMEX2  --金额3
          ,NUMEX3  --金额4
          ,NUMEX4  --金额5
          ,NUMEX5  --金额6
          ,NUMEX6  --金额7
          ,NUMEX7  --金额8
          ,NUMEX8  --金额9
          ,NUMEX9  --金额10
          ,NUMEXA  --金额11
          ,NUMEXB  --金额12
          ,NUMEXC  --金额13
          ,NUMEXD  --金额14
          ,NUMEXE  --金额15
          ,NUMEXF  --金额16
          ,NUMEXG  --金额17
          ,NUMEXH  --金额18
          ,NUMEXI  --金额19
          ,NUMEXJ  --金额20
          ,CHREX0  --字符串1
          ,CHREX1  --字符串2
          ,CHREX2  --字符串3
          ,CHREX3  --字符串4
          ,CHREX4  --字符串5
          ,CHREX5  --字符串6
          ,CHREX6  --字符串7
          ,CHREX7  --字符串8
          ,CHREX8  --字符串9
          ,CHREX9  --字符串10
          ,CHREXA  --字符串11
          ,CHREXB  --字符串12
          ,CHREXC  --字符串13
          ,CHREXD  --字符串14
          ,CHREXE  --字符串15
          ,CHREXF  --字符串16
          ,CHREXG  --字符串17
          ,CHREXH  --字符串18
          ,CHREXI  --字符串19
          ,CHREXJ  --字符串20
          ,DATEX0  --日期1
          ,DATEX1  --日期2
          ,DATEX2  --日期3
          ,DATEX3  --日期4
          ,DATEX4  --日期5
          ,TRANTI  --系统时间
          ,NUME21  --金额21
          ,NUME22  --金额22
          ,NUME23  --金额23
          ,NUME24  --金额24
          ,NUME25  --金额25
          ,NUME26  --金额26
          ,NUME27  --金额27
          ,NUME28  --金额28
          ,NUME29  --金额29
          ,NUME30  --金额30
          ,NUME31  --金额31
          ,NUME32  --金额32
          ,NUME33  --金额33
          ,NUME34  --金额34
          ,NUME35  --金额35
          ,NUME36  --金额36
          ,NUME37  --金额37
          ,NUME38  --金额38
          ,NUME39  --金额39
          ,NUME40  --金额40
          ,NUME41  --金额41
          ,NUME42  --金额42
          ,NUME43  --金额43
          ,NUME44  --金额44
          ,NUME45  --金额45
          ,NUME46  --金额46
          ,NUME47  --金额47
          ,NUME48  --金额48
          ,NUME49  --金额49
          ,NUME50  --金额50
          ,STRKST  --冲正标识（0：正常业务1：冲正业务）
          ,STRKDT  --被冲正业务交易日期
          ,STRKSQ  --被冲正业务交易流水
          ,ETL_DT  --ETL处理日期
          ,ETL_TIMESTAMP  --ETL处理时间戳


     )
  SELECT /*+PARALLEL*/
          STACID  --账套
          ,SYSTID  --交易来源系统编号
          ,TRANDT  --交易日期
          ,TRANSQ  --交易流水
          ,BSNSSQ  --业务流水
          ,TRANBR  --交易机构编号
          ,ACCTBR  --贷款机构
          ,PRCSCD  --处理码
          ,PRODCD  --产品编号
          ,LOANP1  --产品属性1
          ,LOANP2  --产品属性2
          ,LOANP3  --产品属性3
          ,LOANP4  --产品属性4
          ,LOANP5  --产品属性5
          ,LOANP6  --产品属性6
          ,LOANP7  --产品属性7
          ,LOANP8  --产品属性8
          ,LOANP9  --产品属性9
          ,LOANPA  --产品属性10
          ,TRANTP  --交易方式(TR:转账，CS:现金)
          ,CRCYCD  --币种代码
          ,CUSTCD  --客户编号
          ,STATUS  --交易状态(0:未处理1：处理成功2：处理失败3：差错处理中4：差错处理完成)
          ,SERINO  --序号
          ,BATHID  --批次号
          ,EVETDN  --交易方向ADD增加，MINUS减少
          ,TRPRCD  --余额类型
          ,TRANAM  --交易金额
          ,CENTCD  --责任中心
          ,PRSNCD  --员工编号
          ,PRLNCD  --产品线
          ,ACCTNO  --账户
          ,ASSIS0  --辅助核算0（自定义）
          ,ASSIS1  --辅助核算1（自定义）
          ,ASSIS2  --辅助核算2（自定义）
          ,ASSIS3  --辅助核算3（自定义）
          ,ASSIS4  --辅助核算4（自定义）
          ,ASSIS5  --辅助核算5（自定义）
          ,ASSIS6  --辅助核算6（自定义）
          ,ASSIS7  --辅助核算7（自定义）
          ,ASSIS8  --辅助核算8（自定义）
          ,ASSIS9  --辅助核算9（自定义）
          ,NUMEX0  --金额1
          ,NUMEX1  --金额2
          ,NUMEX2  --金额3
          ,NUMEX3  --金额4
          ,NUMEX4  --金额5
          ,NUMEX5  --金额6
          ,NUMEX6  --金额7
          ,NUMEX7  --金额8
          ,NUMEX8  --金额9
          ,NUMEX9  --金额10
          ,NUMEXA  --金额11
          ,NUMEXB  --金额12
          ,NUMEXC  --金额13
          ,NUMEXD  --金额14
          ,NUMEXE  --金额15
          ,NUMEXF  --金额16
          ,NUMEXG  --金额17
          ,NUMEXH  --金额18
          ,NUMEXI  --金额19
          ,NUMEXJ  --金额20
          ,CHREX0  --字符串1
          ,CHREX1  --字符串2
          ,CHREX2  --字符串3
          ,CHREX3  --字符串4
          ,CHREX4  --字符串5
          ,CHREX5  --字符串6
          ,CHREX6  --字符串7
          ,CHREX7  --字符串8
          ,CHREX8  --字符串9
          ,CHREX9  --字符串10
          ,CHREXA  --字符串11
          ,CHREXB  --字符串12
          ,CHREXC  --字符串13
          ,CHREXD  --字符串14
          ,CHREXE  --字符串15
          ,CHREXF  --字符串16
          ,CHREXG  --字符串17
          ,CHREXH  --字符串18
          ,CHREXI  --字符串19
          ,CHREXJ  --字符串20
          ,DATEX0  --日期1
          ,DATEX1  --日期2
          ,DATEX2  --日期3
          ,DATEX3  --日期4
          ,DATEX4  --日期5
          ,TRANTI  --系统时间
          ,NUME21  --金额21
          ,NUME22  --金额22
          ,NUME23  --金额23
          ,NUME24  --金额24
          ,NUME25  --金额25
          ,NUME26  --金额26
          ,NUME27  --金额27
          ,NUME28  --金额28
          ,NUME29  --金额29
          ,NUME30  --金额30
          ,NUME31  --金额31
          ,NUME32  --金额32
          ,NUME33  --金额33
          ,NUME34  --金额34
          ,NUME35  --金额35
          ,NUME36  --金额36
          ,NUME37  --金额37
          ,NUME38  --金额38
          ,NUME39  --金额39
          ,NUME40  --金额40
          ,NUME41  --金额41
          ,NUME42  --金额42
          ,NUME43  --金额43
          ,NUME44  --金额44
          ,NUME45  --金额45
          ,NUME46  --金额46
          ,NUME47  --金额47
          ,NUME48  --金额48
          ,NUME49  --金额49
          ,NUME50  --金额50
          ,STRKST  --冲正标识（0：正常业务1：冲正业务）
          ,STRKDT  --被冲正业务交易日期
          ,STRKSQ  --被冲正业务交易流水
          ,ETL_DT  --ETL处理日期
          ,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IOL.V_TGLS_LOAN_BUSI_H   --主指令表(视图)_视图
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

  END ETL_INIT_O_IOL_TGLS_LOAN_BUSI_H;
/

