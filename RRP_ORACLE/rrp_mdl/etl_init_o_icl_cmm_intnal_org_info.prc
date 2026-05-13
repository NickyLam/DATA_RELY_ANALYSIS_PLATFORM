CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_INTNAL_ORG_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_INTNAL_ORG_INFO
  *  功能描述：内部机构信息表
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_INTNAL_ORG_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_ICL_CMM_INTNAL_ORG_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'O_ICL_CMM_INTNAL_ORG_INFO'; --表名

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_INTNAL_ORG_INFO T ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_INTNAL_ORG_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-内部机构信息表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO
  (      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,ORG_ID  --机构编号
      ,ORG_NAME  --机构名称
      ,ORG_ABBR  --机构简称
      ,PRINC_EMPLY_ID  --负责人员工编号
      ,CBRC_FIN_INST_ID  --银监会金融机构编号
      ,UNIONPAY_FIN_INST_ID  --银联金融机构编号
      ,FIN_INST_IDF_CODE  --金融机构标识码
      ,BUS_LICS_NUM  --营业执照号码
      ,FIN_LICS_NUM  --金融许可证号
      ,PBC_PAY_BANK_NO  --人行支付行号
      ,FIN_INST_CODE  --金融机构编码
      ,HQ_ORG_ID  --总行机构编号
      ,HQ_ORG_NAME  --总行机构名称
      ,BRCH_ID  --分行编号
      ,BRCH_NAME  --分行名称
      ,SUBRCH_ID  --支行编号
      ,SUBRCH_NAME  --支行名称
      ,ORG_TYPE_CD  --机构类型代码
      ,ORG_LEV_CD  --机构级别代码
      ,ORG_STATUS_CD  --机构状态代码
      ,BUS_STATUS_CD  --营业状态代码
      ,BUS_ORG_FLG  --营业机构标志
      ,ENTY_ORG_FLG  --实体机构标志
      ,ACCTI_ORG_FLG  --核算机构标志
      ,ADMIN_ORG_FLG  --行政机构标志
      ,ACCT_INSTIT_FLG  --账务机构标志
      ,VTUAL_ACCTI_ORG_FLG  --虚拟核算机构标志
      ,ADMIN_SUPER_ORG_ID  --行政上级机构编号
      ,ACCT_SUPER_ORG_ID  --账务上级机构编号
      ,ACCTI_SUPER_ORG_ID  --核算上级机构编号
      ,FUNC_ORG_ID  --职能机构编号
      ,FUNC_DEPT_ID  --职能部门编号
      ,CTY_RG_CD  --国家和地区代码
      ,PROV_CD  --省代码
      ,CITY_CD  --市代码
      ,COUNTY_CD  --县代码
      ,PHYS_ADDR  --物理地址
      ,DDD_AREA_CD  --国内长途区号
      ,PHONE  --联系电话
      ,ZIP_CD  --邮政编码
      ,ORG_FOUND_DT  --机构成立日期
      ,ORG_REVO_DT  --机构撤销日期
      ,ORG_START_BUS_TM  --机构开始营业时间
      ,ORG_END_BUS_TM  --机构结束营业时间
      ,ORG_HIBCHY_CD  --机构层级代码
      ,ORG_EN_NAME  --机构英文名称
      ,ORG_EN_ABBR  --机构英文简称
      ,TAX_REGI_CERT_NUM  --税务登记证号
      ,PAY_SYS_BANK_NO  --支付系统银行行号
      ,ORGNZ_CD  --组织机构代码
      ,DTL_ORG_FLG  --明细机构标志
      ,SWIFTCODE  --SWIFTCODE
      ,IDD_AREA_CD  --国际长途区号
      ,EXT_NUM  --分机号
      ,SERV_TEL  --服务电话
      ,E_MAIL  --电子邮箱
      ,URL  --网址
      ,PBC_BELONG_CITY_CD  --人行所属城市代码
      ,PBC_BELONG_CITY  --人行所属城市
    ,JOB_CD --任务代码
    )
    SELECT

      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,ORG_ID  --机构编号
      ,ORG_NAME  --机构名称
      ,ORG_ABBR  --机构简称
      ,PRINC_EMPLY_ID  --负责人员工编号
      ,CBRC_FIN_INST_ID  --银监会金融机构编号
      ,UNIONPAY_FIN_INST_ID  --银联金融机构编号
      ,FIN_INST_IDF_CODE  --金融机构标识码
      ,BUS_LICS_NUM  --营业执照号码
      ,FIN_LICS_NUM  --金融许可证号
      ,PBC_PAY_BANK_NO  --人行支付行号
      ,FIN_INST_CODE  --金融机构编码
      ,HQ_ORG_ID  --总行机构编号
      ,HQ_ORG_NAME  --总行机构名称
      ,BRCH_ID  --分行编号
      ,BRCH_NAME  --分行名称
      ,SUBRCH_ID  --支行编号
      ,SUBRCH_NAME  --支行名称
      ,ORG_TYPE_CD  --机构类型代码
      ,CASE WHEN ORG_LEV_CD='00' THEN '01'
            WHEN ORG_LEV_CD='10' THEN '02'
            WHEN ORG_LEV_CD='20' THEN '03'
            WHEN ORG_LEV_CD='80' THEN '06'
            WHEN ORG_LEV_CD='90' THEN '07'
            ELSE ORG_LEV_CD END   --机构级别代码
      ,ORG_STATUS_CD  --机构状态代码
      ,BUS_STATUS_CD  --营业状态代码
      ,BUS_ORG_FLG  --营业机构标志
      ,ENTY_ORG_FLG  --实体机构标志
      ,ACCTI_ORG_FLG  --核算机构标志
      ,ADMIN_ORG_FLG  --行政机构标志
      ,ACCT_INSTIT_FLG  --账务机构标志
      ,VTUAL_ACCTI_ORG_FLG  --虚拟核算机构标志
      ,ADMIN_SUPER_ORG_ID  --行政上级机构编号
      ,ACCT_SUPER_ORG_ID  --账务上级机构编号
      ,ACCTI_SUPER_ORG_ID  --核算上级机构编号
      ,FUNC_ORG_ID  --职能机构编号
      ,FUNC_DEPT_ID  --职能部门编号
      ,CTY_RG_CD  --国家和地区代码
      ,PROV_CD  --省代码
      ,CITY_CD  --市代码
      ,COUNTY_CD  --县代码
      ,PHYS_ADDR  --物理地址
      ,DDD_AREA_CD  --国内长途区号
      ,PHONE  --联系电话
      ,ZIP_CD  --邮政编码
      ,ORG_FOUND_DT  --机构成立日期
      ,ORG_REVO_DT  --机构撤销日期
      ,ORG_START_BUS_TM  --机构开始营业时间
      ,ORG_END_BUS_TM  --机构结束营业时间
      ,ORG_HIBCHY_CD  --机构层级代码
      ,ORG_EN_NAME  --机构英文名称
      ,ORG_EN_ABBR  --机构英文简称
      ,TAX_REGI_CERT_NUM  --税务登记证号
      ,PAY_SYS_BANK_NO  --支付系统银行行号
      ,ORGNZ_CD  --组织机构代码
      ,DTL_ORG_FLG  --明细机构标志
      ,SWIFTCODE  --SWIFTCODE
      ,IDD_AREA_CD  --国际长途区号
      ,EXT_NUM  --分机号
      ,SERV_TEL  --服务电话
      ,E_MAIL  --电子邮箱
      ,URL  --网址
      ,PBC_BELONG_CITY_CD  --人行所属城市代码
      ,PBC_BELONG_CITY  --人行所属城市
    ,JOB_CD --任务代码
    FROM ICL.V_CMM_INTNAL_ORG_INFO  --视图-内部机构信息表
         WHERE ETL_DT BETWEEN TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1--上月末
        AND TO_DATE(V_P_DATE,'YYYYMMDD') --跑批日
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

  END ETL_INIT_O_ICL_CMM_INTNAL_ORG_INFO;
/

