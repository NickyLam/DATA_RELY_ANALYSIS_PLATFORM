CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_INDV_CUST_BASIC_INFO(I_P_DATE IN INTEGER,
                                                               O_ERRCODE OUT VARCHAR2
                                                               )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_INDV_CUST_BASIC_INFO
  *  功能描述：个人客户基本信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_INDV_CUST_BASIC_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20231109  hulj     优化O层
  *             3    20240312  YJY      优化脚本，仅保存上月末和当天跑批的数据
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                 --处理步骤
  V_P_DATE    VARCHAR2(8);                  --跑批数据日期
  V_STARTTIME DATE;                         --处理开始时间
  V_ENDTIME   DATE;                         --处理结束时间
  V_LAST_MON_END VARCHAR2(8);               --上月月末 --ADD BY YJY 20240312
  V_SQLCOUNT  INTEGER := 0;                 --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);                --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);                --任务名称
  V_PART_NAME VARCHAR2(200);                --分区名
  V_TAB_NAME  VARCHAR2(100):= 'O_ICL_CMM_INDV_CUST_BASIC_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_INDV_CUST_BASIC_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';   --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE    := TO_CHAR( I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  V_LAST_MON_END := TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_P_DATE,'YYYY-MM-DD'),-1)),'YYYYMMDD'); --上月月末  --ADD BY YJY 20240312

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO T WHERE  T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO';  --MODIFY BY YJY 20240312
  ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '3', O_ERRCODE);
  ETL_PARTITION_ADD(V_LAST_MON_END, V_TAB_NAME, '3', O_ERRCODE);
  --EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-个人客户基本信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND */ INTO RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO
    (ETL_DT                     --数据日期
    ,LP_ID                      --法人编号
    ,CUST_ID                    --客户编号
    ,CUST_TYPE_CD               --客户类型代码
    ,CERT_TYPE_CD               --证件类型代码
    ,CERT_NO                    --证件号码
    ,CERT_EXP_DT                --证件到期日期
    ,CERT_ISSUE_ORG             --证件签发机关
    ,CUST_NAME                  --客户名称
    ,CUST_EN_NAME               --客户英文名称
    ,OPEN_ACCT_DT               --开户日期
    ,BELONG_ORG_ID              --所属机构编号
    ,OPEN_ACCT_TELLER_ID        --开户柜员编号
    ,GENDER_CD                  --性别代码
    ,OPEN_ACCT_CHN_CD           --开户渠道代码
    ,BIRTH_DT                   --出生日期
    ,MARRIAGE_SITU_CD           --婚姻状况代码
    ,RESD_STATUS_CD             --居住状态代码
    ,ESTATE_VAL_CD              --房产价值代码
    ,OWNER_TYPE_CD              --业主类型代码
    ,POLITIC_STATUS_CD          --政治面貌代码
    ,NATION_CD                  --国籍代码
    ,DIST_CD                    --行政区域代码
    ,RG_CD                      --地区代码
    ,NATIONTY_CD                --民族代码
    ,NATI_PLACE                 --籍贯
    ,CUST_STATUS_CD             --客户状态代码
    ,DEPOSITR_CATE_CD           --存款人类别代码
    ,PROV_PULATION_TYPE_CD      --供养人口类型代码
    ,CHILD_NUMBER_CD            --子女人数代码
    ,CONT_NUM                   --联系号码
    ,OPEN_ACCT_RSRV_MOBILE_NO   --开户预留手机号码
    ,ELEC_MAIL_ADDR             --电子邮件地址
    ,CUST_LEV_CD                --客户级别代码
    ,EDU_CD                     --学历代码
    ,DEGREE_CD                  --学位代码
    ,GRAD_SCH                   --毕业学校
    ,TITLE_CD                   --职称代码
    ,POST_CD                    --职务代码
    ,CAREER_CD                  --职业代码
    ,POSTA_ADDR                 --通讯地址
    ,COMM_ZIP_CD                --通讯邮政编码
    ,RESDNT_ADDR                --常住地址
    ,RESDNT_ZIP_CD              --常住邮政编码
    ,RPR_SITE                   --户口所在地
    ,FAMILY_ADDR                --家庭地址
    ,FAMILY_ZIP_CD              --家庭邮政编码
    ,NOME_PHONE_NUM             --家庭电话号码
    ,WORK_UNIT_NAME             --工作单位名称
    ,WORK_UNIT_ADDR             --工作单位地址
    ,WORK_UNIT_TEL              --工作单位电话
    ,WORK_UNIT_ZIP_CD           --工作单位邮政编码
    ,WORK_UNIT_CHAR_CD          --工作单位性质代码
    ,CORP_BL_INDUTY_TYPE_CD     --单位所属行业类型代码
    ,CORP_WORK_YEARS            --单位工作年限
    ,INDV_MON_INCO              --个人月收入
    ,INDV_ANL_INCO              --个人年收入
    ,FAMILY_MON_INCO            --家庭月收入
    ,FAMILY_ANL_INCO            --家庭年收入
    ,TAX_RESDNT_IDTI_CD         --税收居民身份代码
    ,TAX_RED_CTY_CD             --税收居民国家代码
    ,TAX_NUM                    --纳税人识别号
    ,TAX_NUM_NULL_RS_DESCB      --纳税人识别号空值原因描述
    ,STAMENT_FLG                --自证声明标志
    ,INDV_BUS_FLG               --个体工商户标志
    ,SM_BUS_OWNER_FLG           --小微企业主标志
    ,RESDNT_FLG                 --居民标志
    ,FARM_FLG                   --农户标志
    ,GHB_EMPLY_FLG              --本行员工标志
    ,GHB_SHARD_FLG              --本行股东标志
    ,CRDT_CUST_FLG              --授信客户标志
    ,REAL_NAME_FLG              --实名标志
    ,DOM_OVERS_FLG              --境内外标志
    ,LOCAL_ESTATE_FLG           --当地房产标志
    ,LOCAL_SOCI_SECU_FLG        --当地社保标志
    ,CTYSD_CONTR_OPER_ACCT_FLG  --农村承包经营户标志
    ,GHB_RELA_PEOP_FLG          --本行关系人标志
    ,HXB_SHARD_FLG              --我行股东标志
    ,HXB_TRAST_INTER_BUS_FLG    --在我行办理过中间业务标志
    ,HXB_PAYOFF_SAL_ACCT_FLG    --我行代发工资户标志
    ,HXB_REG_CUST_FLG           --我行定期客户标志
    ,HXB_FINC_CUST_FLG          --我行理财客户标志
    ,HXB_VIP_CUST_IDF           --我行VIP客户标识
    ,SPOUSE_AND_CHILD_IMG_FLG   --配偶及子女移民标志
    ,ENJOY_CTY_PREFR_POLICY_FLG --享受国家优惠政策标志
    ,CUST_MGR_ID                --客户经理编号
    ,EMPLOY_TYPE_CD             --雇佣类型代码
    ,CLOS_ACCT_DT               --销户日期
    ,CLOS_ACCT_ORG_ID           --销户机构编号
    ,CLOS_ACCT_TELLER_ID        --销户柜员编号
    ,HAVE_CAR_FLG               --拥有汽车标志
    ,SALAR_FLG                  --受薪人士标志
    ,CIV_SERT_FLG               --公务员标志
    ,TAX_RED_EN_NAME            --税收居民英文名称
    ,OTHER_CAREER_INFO          --其他职业信息
    ,CURT_CORP_EMPYT_DT         --现单位入职日期
    ,CONT_NUM_IS_SELF_FLG       --联系号码是否本人标志
    ,RELA_TRAN_FLG              --关联交易标志
    ,JOB_CD                     --任务代码
    )
  SELECT 
     ETL_DT                     --数据日期
    ,LP_ID                      --法人编号
    ,CUST_ID                    --客户编号
    ,CUST_TYPE_CD               --客户类型代码
    ,CERT_TYPE_CD               --证件类型代码
    ,CERT_NO                    --证件号码
    ,CERT_EXP_DT                --证件到期日期
    ,CERT_ISSUE_ORG             --证件签发机关
    ,CUST_NAME                  --客户名称
    ,CUST_EN_NAME               --客户英文名称
    ,OPEN_ACCT_DT               --开户日期
    ,BELONG_ORG_ID              --所属机构编号
    ,OPEN_ACCT_TELLER_ID        --开户柜员编号
    ,GENDER_CD                  --性别代码
    ,OPEN_ACCT_CHN_CD           --开户渠道代码
    ,BIRTH_DT                   --出生日期
    ,MARRIAGE_SITU_CD           --婚姻状况代码
    ,RESD_STATUS_CD             --居住状态代码
    ,ESTATE_VAL_CD              --房产价值代码
    ,OWNER_TYPE_CD              --业主类型代码
    ,POLITIC_STATUS_CD          --政治面貌代码
    ,NATION_CD                  --国籍代码
    ,DIST_CD                    --行政区域代码
    ,RG_CD                      --地区代码
    ,NATIONTY_CD                --民族代码
    ,NATI_PLACE                 --籍贯
    ,CUST_STATUS_CD             --客户状态代码
    ,DEPOSITR_CATE_CD           --存款人类别代码
    ,PROV_PULATION_TYPE_CD      --供养人口类型代码
    ,CHILD_NUMBER_CD            --子女人数代码
    ,CONT_NUM                   --联系号码
    ,OPEN_ACCT_RSRV_MOBILE_NO   --开户预留手机号码
    ,ELEC_MAIL_ADDR             --电子邮件地址
    ,CUST_LEV_CD                --客户级别代码
    ,EDU_CD                     --学历代码
    ,DEGREE_CD                  --学位代码
    ,GRAD_SCH                   --毕业学校
    ,TITLE_CD                   --职称代码
    ,POST_CD                    --职务代码
    ,CAREER_CD                  --职业代码
    ,POSTA_ADDR                 --通讯地址
    ,COMM_ZIP_CD                --通讯邮政编码
    ,RESDNT_ADDR                --常住地址
    ,RESDNT_ZIP_CD              --常住邮政编码
    ,RPR_SITE                   --户口所在地
    ,FAMILY_ADDR                --家庭地址
    ,FAMILY_ZIP_CD              --家庭邮政编码
    ,NOME_PHONE_NUM             --家庭电话号码
    ,WORK_UNIT_NAME             --工作单位名称
    ,WORK_UNIT_ADDR             --工作单位地址
    ,WORK_UNIT_TEL              --工作单位电话
    ,WORK_UNIT_ZIP_CD           --工作单位邮政编码
    ,WORK_UNIT_CHAR_CD          --工作单位性质代码
    ,CORP_BL_INDUTY_TYPE_CD     --单位所属行业类型代码
    ,CORP_WORK_YEARS            --单位工作年限
    ,INDV_MON_INCO              --个人月收入
    ,INDV_ANL_INCO              --个人年收入
    ,FAMILY_MON_INCO            --家庭月收入
    ,FAMILY_ANL_INCO            --家庭年收入
    ,TAX_RESDNT_IDTI_CD         --税收居民身份代码
    ,TAX_RED_CTY_CD             --税收居民国家代码
    ,TAX_NUM                    --纳税人识别号
    ,TAX_NUM_NULL_RS_DESCB      --纳税人识别号空值原因描述
    ,STAMENT_FLG                --自证声明标志
    ,INDV_BUS_FLG               --个体工商户标志
    ,SM_BUS_OWNER_FLG           --小微企业主标志
    ,RESDNT_FLG                 --居民标志
    ,FARM_FLG                   --农户标志
    ,GHB_EMPLY_FLG              --本行员工标志
    ,GHB_SHARD_FLG              --本行股东标志
    ,CRDT_CUST_FLG              --授信客户标志
    ,REAL_NAME_FLG              --实名标志
    ,DOM_OVERS_FLG              --境内外标志
    ,LOCAL_ESTATE_FLG           --当地房产标志
    ,LOCAL_SOCI_SECU_FLG        --当地社保标志
    ,CTYSD_CONTR_OPER_ACCT_FLG  --农村承包经营户标志
    ,GHB_RELA_PEOP_FLG          --本行关系人标志
    ,HXB_SHARD_FLG              --我行股东标志
    ,HXB_TRAST_INTER_BUS_FLG    --在我行办理过中间业务标志
    ,HXB_PAYOFF_SAL_ACCT_FLG    --我行代发工资户标志
    ,HXB_REG_CUST_FLG           --我行定期客户标志
    ,HXB_FINC_CUST_FLG          --我行理财客户标志
    ,HXB_VIP_CUST_IDF           --我行VIP客户标识
    ,SPOUSE_AND_CHILD_IMG_FLG   --配偶及子女移民标志
    ,ENJOY_CTY_PREFR_POLICY_FLG --享受国家优惠政策标志
    ,CUST_MGR_ID                --客户经理编号
    ,EMPLOY_TYPE_CD             --雇佣类型代码
    ,CLOS_ACCT_DT               --销户日期
    ,CLOS_ACCT_ORG_ID           --销户机构编号
    ,CLOS_ACCT_TELLER_ID        --销户柜员编号
    ,HAVE_CAR_FLG               --拥有汽车标志
    ,SALAR_FLG                  --受薪人士标志
    ,CIV_SERT_FLG               --公务员标志
    ,TAX_RED_EN_NAME            --税收居民英文名称
    ,OTHER_CAREER_INFO          --其他职业信息
    ,CURT_CORP_EMPYT_DT         --现单位入职日期
    ,CONT_NUM_IS_SELF_FLG       --联系号码是否本人标志
    ,RELA_TRAN_FLG              --关联交易标志
    ,JOB_CD                     --任务代码
    FROM ICL.V_CMM_INDV_CUST_BASIC_INFO --视图-个人客户基本信息
   WHERE ETL_DT IN (TO_DATE(V_P_DATE,'YYYYMMDD'),TO_DATE(V_LAST_MON_END,'YYYYMMDD')); --MODIFY BY YJY 20240312  保存当天数据以及上月月末数据

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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

END ETL_O_ICL_CMM_INDV_CUST_BASIC_INFO;
/

