CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_TGLS_GLI_VCHR_H(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_TGLS_GLI_VCHR_H
  *  功能描述：接口传票历史表
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_TGLS_GLI_VCHR_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_TGLS_GLI_VCHR_H'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IOL_TGLS_GLI_VCHR_H';

  V_STEP_DESC  := '装入目标表';
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_TGLS_GLI_VCHR_H NOLOGGING
    (
				STACID  --账套标识
				,TRANDT  --总账日期（总账入账日期）
				,TRANSQ  --总账流水（总账入账流水）
				,VCHRSQ  --传票流水
				,TRANBR  --交易机构编号
				,ACCTBR  --账务机构编号
				,ITEMCD  --科目编号
				,CRCYCD  --币种代码
				,CENTCD  --责任中心辅助核算
				,PRSNCD  --职员辅助核算
				,CUSTCD  --往来单位（辅助）
				,PRDUCD  --产品辅助核算
				,PRLNCD  --业务条线
				,ACCTNO  --总账账号
				,TRANTP  --交易类型（TR,CS）
				,AMNTCD  --借贷方向（D:借(收)C:贷(付)）
				,TRANAM  --交易金额
				,SMRYTX  --摘要
				,EXCHCN  --中间价
				,EXCHUS  --折算率
				,USERCD  --用户代码
				,SOURDT  --源系统日期
				,SOURSQ  --源系统流水号（凭证号）
				,SOURST  --源系统标识（LTTS-综合业务ACCT-财务）
				,TOITEM  --对方科目编号
				,ASSIS0  --渠道编号
				,ASSIS1  --产品编号
				,ASSIS2  --辅助核算2
				,ASSIS3  --辅助核算3
				,ASSIS4  --辅助核算4
				,ASSIS5  --辅助核算5
				,ASSIS6  --辅助核算6
				,ASSIS7  --辅助核算7
				,ASSIS8  --辅助核算8
				,ASSIS9  --辅助核算9
				,DEALST  --处理状态(0：未处理1:成功2：失败5：不处理6：已回执)
				,PRCSCD  --交易码
				,ITEMNA  --科目名称
				,PRCSNA  --交易码名称
				,STRKST  --冲正标识（0：正常业务1：冲正业务）
				,STRKDT  --被冲正业务交易日期
				,STRKSQ  --被冲正业务交易流水
				,CRCYSD  --本位币
				,TRANEQ  --折算金额（本位币）
				,TAXBST  --日终应税流水处理状态(0：未处理1:成功2：失败5：不处理6：已回执)
				,DEALMG  --价税分离错误信息
				,TRANNM  --交易笔数
				,TRANST  --处理状态（1已处理0未处理）
				,TAXAM  --税额
				,ETL_DT  --ETL处理日期
				,ETL_TIMESTAMP  --ETL处理时间戳

     )
  SELECT /*+PARALLEL*/
				STACID  --账套标识
				,TRANDT  --总账日期（总账入账日期）
				,TRANSQ  --总账流水（总账入账流水）
				,VCHRSQ  --传票流水
				,TRANBR  --交易机构编号
				,ACCTBR  --账务机构编号
				,ITEMCD  --科目编号
				,CRCYCD  --币种代码
				,CENTCD  --责任中心辅助核算
				,PRSNCD  --职员辅助核算
				,CUSTCD  --往来单位（辅助）
				,PRDUCD  --产品辅助核算
				,PRLNCD  --业务条线
				,ACCTNO  --总账账号
				,TRANTP  --交易类型（TR,CS）
				,AMNTCD  --借贷方向（D:借(收)C:贷(付)）
				,TRANAM  --交易金额
				,SMRYTX  --摘要
				,EXCHCN  --中间价
				,EXCHUS  --折算率
				,USERCD  --用户代码
				,SOURDT  --源系统日期
				,SOURSQ  --源系统流水号（凭证号）
				,SOURST  --源系统标识（LTTS-综合业务ACCT-财务）
				,TOITEM  --对方科目编号
				,ASSIS0  --渠道编号
				,ASSIS1  --产品编号
				,ASSIS2  --辅助核算2
				,ASSIS3  --辅助核算3
				,ASSIS4  --辅助核算4
				,ASSIS5  --辅助核算5
				,ASSIS6  --辅助核算6
				,ASSIS7  --辅助核算7
				,ASSIS8  --辅助核算8
				,ASSIS9  --辅助核算9
				,DEALST  --处理状态(0：未处理1:成功2：失败5：不处理6：已回执)
				,PRCSCD  --交易码
				,ITEMNA  --科目名称
				,PRCSNA  --交易码名称
				,STRKST  --冲正标识（0：正常业务1：冲正业务）
				,STRKDT  --被冲正业务交易日期
				,STRKSQ  --被冲正业务交易流水
				,CRCYSD  --本位币
				,TRANEQ  --折算金额（本位币）
				,TAXBST  --日终应税流水处理状态(0：未处理1:成功2：失败5：不处理6：已回执)
				,DEALMG  --价税分离错误信息
				,TRANNM  --交易笔数
				,TRANST  --处理状态（1已处理0未处理）
				,TAXAM  --税额
				,ETL_DT  --ETL处理日期
				,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IOL.V_TGLS_GLI_VCHR_H   --主指令表(视图)_视图
   ;

 V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


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

  END ETL_INIT_O_IOL_TGLS_GLI_VCHR_H;
/

