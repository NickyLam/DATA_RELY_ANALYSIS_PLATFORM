CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_ADD_DG_003_MONEY(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_ADD_DG_003_MONEY
  *  功能描述：补录表-对公-账务基表。
  *  创建日期：20221213
  *  开发人员：hulijuan
  *  来源表：  ICL_CMM_BILL_DISCNT_INFO      -- 票据贴现信息
  *            ICL.CMM_CORP_LOAN_CONT_INFO   --对公贷款合同信息表
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款借据信息表
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款账户信息
  *            ICL.CMM_BILL_CENTER_INFO      --票据中心信息
  *            ICL.CMM_CORP_CUST_BASIC_INFO  --对公客户基本信息表
  *            ICL.CMM_INTNAL_ORG_INFO       --内部机构信息表
  *  目标表：  ADD_DG_003_MONEY  --账务基表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：
     序号  修改日期  修改人   修改原因
  *   1    20221115  hulj     首次创建。
  *   2    20230413  liuyu    调整带*行业码值给到具体行业名称，而不是给目标五大产业带*
  *   3    20230530  liuyu    调整继承上天数据逻辑
  *   4    20230601  liuyu    补录下发机构调整 贴现取票据表机构号 同步表内借据表逻辑
  *   5    20230911  lwb      修改贴现数字核心产业部分的逻辑，改为取中文映射
  *   6    20231207  HYF      新增是否玩具业等6个字段
  *   7    20240124  hulj     新增字段是否专精特新中小企业、是否监管名单中的专精特新中小企业,
  *                           根据业务口径是否专精特新中小企业从ECIF出数,是否监管名单中的专精特新中小企业从业务提供配置名单出数
  *   8    20240220  YJY      1）对”是否专精特新中小企业”进行转码
                              2）新增是否养老产业
  *   9    20240226  YJY      新增"是否投向政府和社会资本合作（PPP）项目","是否新机制发放贷款"
  *   10   20240227  YJY      ”是否专精特新中小企业”非继承逻辑，每天下发补录表数据为直取ecif标识数据，如需调整请月底前在ecif系统调整。
                              如需补录，只能在1号10点前补录的数据才会生效，其余时间补录的数据只有当天生效，不会继承下来。
  *   11   20240619  HYF      是否投向高技术产业、投向数字经济核心产业大类、数字经济核心产业名称、是否养老产业、投向战略性新兴产业门类、
  *                           战略性新兴产业名称、是否投向文化产业大类、是否投向政府和社会资本合作（PPP）项目、是否新机制发放贷款
  *                           调整为直取信贷不需补录 20240619
  *   12   20240624  HYF      补上贴现部分逻辑
  *   13   20240806  LWB      新增是否因资金链断裂导致的逾期未交付项目_开发融资，开发融资_贷款字段
  *   14   20241022  HYF      调整是否关系人保证贷款，改为直取信贷标识
  *   15   20241030  HYF      是否知识密集型产业取当天跑批数据不再补录
  ************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                        -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                              -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30)   := 'ETL_ADD_DG_003_MONEY';   -- 程序名称
  V_TABLE_NAME  VARCHAR2(30)   := 'ADD_DG_003_MONEY';       -- 报表名称
  V_PART_NAME   VARCHAR2(100);                              -- 分区名称
  V_P_DATE      VARCHAR2(8);                                -- 跑批数据日期
  V_STARTTIME   DATE;                                       -- 处理开始时间
  V_ENDTIME     DATE;                                       -- 处理结束时间
  V_SQLCOUNT    INTEGER        := 0;                        -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                              -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                               -- 来源系统
  M_DATA_DATE   VARCHAR2(8);                                --数据日期YYYYMMDD

BEGIN
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  V_STEP      := 1;
  V_STEP_DESC := '删除当期临时表数据';
  V_STARTTIME := SYSDATE;

  SELECT MAX(TT.DATA_DATE) INTO M_DATA_DATE FROM ADD_DG_003_MONEY_ETL TT WHERE TT.DATA_DATE < V_P_DATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE ADD_DG_003_MONEY_L';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADD_DG_003_MONEY';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := 2;
  V_STEP_DESC := '备份当期数据-从ETL表继承';
  V_STARTTIME := SYSDATE;

  /************************备份当期数据*******************/
  INSERT INTO ADD_DG_003_MONEY_L NOLOGGING
     (
       DATA_DATE,       --01 数据日期,
       ACCT_ORG_NUM,    --02 账务机构编号,
       JYWYM,           --03 交易唯一码,
       ZHWYM,           --04 账户唯一码,
       KHWYM,           --05 客户唯一码,
       KHMC,            --06 客户名称,
       PJBH,            --07 票据编号,
       JBJGMC,          --08 经办机构名称,
       JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
       ZWJGMC,          --10 账务机构名称,
       ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
       TXGTJCYML,       --12 投向高技术产业门类,
       SFTXGJSCY,       --13 是否投向高技术产业,
       TXGJSZZYDLMC,    --14 投向高技术制造业大类,
       GJSCYMC,         --15 高技术产业名称,
       SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
       ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
       TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
       SZJJHXCYMC,      --19 数字经济核心产业名称,
       TXZLXXXCYML,     --20 投向战略性新兴产业门类,
       ZYXXXCYMC,       --21 战略性新兴产业名称,
       SFTXWHCYDL,      --22 是否投向文化产业大类,
       WHCYMC,          --23 文化产业名称,
       SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
       SFYSHZ,          --25 是否银税合作,
       SFNYCYHLTQY,     --26 是否农业产业化龙头企业
       SFYQ,            --27 是否延期,
       SYS_SOURCE,      --28 来源系统,
       SFGXRBZ,         --29 是否关系人保证,
       KHZBKHJLKHH,     --30 客户主办客户经理客户号,
       KHZBGYH,         --31 客户主办柜员号,
       KHZBKHJLMC,      --32 客户主办客户经理名称,
       KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
       JJZBKHJLH,       --34 借据主办客户经理号,
       JJZBGYH,         --35 借据主办柜员号,
       JJZBKHJLMC,      --36 借据主办客户经理名称,
       JJZBKHJLSSJG,    --37 借据主办客户经理所属机构
       SFWJY,           --38 是否玩具业
       WJHYMC,          --39 玩具业行业名称
       SFZFZDXM,        --40 是否政府重点项目
       SFSQQY,          --41 是否涉侨企业
       GYLRZQY,         --42 供应链融资企业
       SFTXHSFDCY,      --43 是否投向海上风电产业
       SFTXXXCNCY,      --44 是否投向新型储能产业
       SFZJTXZXQY,      --45 是否专精特新中小企业
       SFJGMDZDZJTXZXQY, --46 是否监管名单中的专精特新中小企业
       SFYLCY,           --47 是否养老产业
       SFTXZFHSHZBHZ_PPP_XM, --48 是否投向政府和社会资本合作（PPP）项目
       SFXJZFFDK,         --49 是否新机制发放贷款
       SFYZLLDLYQWJFXM,   --50 是否因资金链断裂导致的逾期未交付项目
       SFYZLLDLYQWJFXMKFRZ,--51 是否因资金链断裂导致的逾期未交付项目_开发融资
       SFYZLLDLYQWJFXMKFRZDK--52 是否因资金链断裂导致的逾期未交付项目_开发融资_贷款
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE,        --01 数据日期,
           ACCT_ORG_NUM,    --02 账务机构编号,
           JYWYM,           --03 交易唯一码,
           ZHWYM,           --04 账户唯一码,
           KHWYM,           --05 客户唯一码,
           KHMC,            --06 客户名称,
           PJBH,            --07 票据编号,
           JBJGMC,          --08 经办机构名称,
           JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
           ZWJGMC,          --10 账务机构名称,
           ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
           TXGTJCYML,       --12 投向高技术产业门类,
           SFTXGJSCY,       --13 是否投向高技术产业,
           TXGJSZZYDLMC,    --14 投向高技术制造业大类,
           GJSCYMC,         --15 高技术产业名称,
           SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
           ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
           TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
           SZJJHXCYMC,      --19 数字经济核心产业名称,
           TXZLXXXCYML,     --20 投向战略性新兴产业门类,
           ZYXXXCYMC,       --21 战略性新兴产业名称,
           SFTXWHCYDL,      --22 是否投向文化产业大类,
           WHCYMC,          --23 文化产业名称,
           SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
           SFYSHZ,          --25 是否银税合作,
           SFNYCYHLTQY,     --26 是否农业产业化龙头企业
           SFYQ,            --27 是否延期,
           SYS_SOURCE,      --28 来源系统,
           SFGXRBZ,         --29 是否关系人保证,
           KHZBKHJLKHH,     --30 客户主办客户经理客户号,
           KHZBGYH,         --31 客户主办柜员号,
           KHZBKHJLMC,      --32 客户主办客户经理名称,
           KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
           JJZBKHJLH,       --34 借据主办客户经理号,
           JJZBGYH,         --35 借据主办柜员号,
           JJZBKHJLMC,      --36 借据主办客户经理名称,
           JJZBKHJLSSJG,    --37 借据主办客户经理所属机构
           SFWJY,           --38 是否玩具业
           WJHYMC,          --39 玩具业行业名称
           SFZFZDXM,        --40 是否政府重点项目
           SFSQQY,          --41 是否涉侨企业
           GYLRZQY,         --42 供应链融资企业
           SFTXHSFDCY,      --43 是否投向海上风电产业
           SFTXXXCNCY,      --44 是否投向新型储能产业
           SFZJTXZXQY,      --45 是否专精特新中小企业
           SFJGMDZDZJTXZXQY, --46 是否监管名单中的专精特新中小企业
           SFYLCY,           --47 是否养老产业
           SFTXZFHSHZBHZ_PPP_XM, --48 是否投向政府和社会资本合作（PPP）项目
           SFXJZFFDK,         --49 是否新机制发放贷款
           SFYZLLDLYQWJFXM,   --50 是否因资金链断裂导致的逾期未交付项目
           SFYZLLDLYQWJFXMKFRZ,--51 是否因资金链断裂导致的逾期未交付项目_开发融资
           SFYZLLDLYQWJFXMKFRZDK--52 是否因资金链断裂导致的逾期未交付项目_开发融资_贷款

      FROM (SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.JYWYM ORDER BY A.SYS_OPER_DATE DESC) RN
              FROM ADD_DG_003_MONEY_ETL A
             WHERE A.DATA_DATE =  (SELECT MAX(DATA_DATE) FROM ADD_DG_003_MONEY_ETL)
            ) T
    WHERE T.RN = 1
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 3;
  V_STEP_DESC := '备份当期数据-从ADD表继承';
  V_STARTTIME := SYSDATE;

  /************************备份当期数据*******************/
  INSERT INTO ADD_DG_003_MONEY_L NOLOGGING
     (
       DATA_DATE,       --01 数据日期,
       ACCT_ORG_NUM,    --02 账务机构编号,
       JYWYM,           --03 交易唯一码,
       ZHWYM,           --04 账户唯一码,
       KHWYM,           --05 客户唯一码,
       KHMC,            --06 客户名称,
       PJBH,            --07 票据编号,
       JBJGMC,          --08 经办机构名称,
       JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
       ZWJGMC,          --10 账务机构名称,
       ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
       TXGTJCYML,       --12 投向高技术产业门类,
       SFTXGJSCY,       --13 是否投向高技术产业,
       TXGJSZZYDLMC,    --14 投向高技术制造业大类,
       GJSCYMC,         --15 高技术产业名称,
       SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
       ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
       TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
       SZJJHXCYMC,      --19 数字经济核心产业名称,
       TXZLXXXCYML,     --20 投向战略性新兴产业门类,
       ZYXXXCYMC,       --21 战略性新兴产业名称,
       SFTXWHCYDL,      --22 是否投向文化产业大类,
       WHCYMC,          --23 文化产业名称,
       SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
       SFYSHZ,          --25 是否银税合作,
       SFNYCYHLTQY,     --26 是否农业产业化龙头企业
       SFYQ,            --27 是否延期,
       SYS_SOURCE,      --28 来源系统,
       SFGXRBZ,         --29 是否关系人保证,
       KHZBKHJLKHH,     --30 客户主办客户经理客户号,
       KHZBGYH,         --31 客户主办柜员号,
       KHZBKHJLMC,      --32 客户主办客户经理名称,
       KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
       JJZBKHJLH,       --34 借据主办客户经理号,
       JJZBGYH,         --35 借据主办柜员号,
       JJZBKHJLMC,      --36 借据主办客户经理名称,
       JJZBKHJLSSJG,    --37 借据主办客户经理所属机构
       SFWJY,           --38 是否玩具业
       WJHYMC,          --39 玩具业行业名称
       SFZFZDXM,        --40 是否政府重点项目
       SFSQQY,          --41 是否涉侨企业
       GYLRZQY,         --42 供应链融资企业
       SFTXHSFDCY,      --43 是否投向海上风电产业
       SFTXXXCNCY,      --44 是否投向新型储能产业
       SFZJTXZXQY,      --45 是否专精特新中小企业
       SFJGMDZDZJTXZXQY, --46 是否监管名单中的专精特新中小企业
       SFYLCY,           --47 是否养老产业
       SFTXZFHSHZBHZ_PPP_XM, --48 是否投向政府和社会资本合作（PPP）项目
       SFXJZFFDK,         --49 是否新机制发放贷款
       SFYZLLDLYQWJFXM,   --50 是否因资金链断裂导致的逾期未交付项目
       SFYZLLDLYQWJFXMKFRZ,--51 是否因资金链断裂导致的逾期未交付项目_开发融资
       SFYZLLDLYQWJFXMKFRZDK--52 是否因资金链断裂导致的逾期未交付项目_开发融资_贷款
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE,        --01 数据日期,
           ACCT_ORG_NUM,    --02 账务机构编号,
           JYWYM,           --03 交易唯一码,
           ZHWYM,           --04 账户唯一码,
           KHWYM,           --05 客户唯一码,
           KHMC,            --06 客户名称,
           PJBH,            --07 票据编号,
           JBJGMC,          --08 经办机构名称,
           JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
           ZWJGMC,          --10 账务机构名称,
           ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
           TXGTJCYML,       --12 投向高技术产业门类,
           SFTXGJSCY,       --13 是否投向高技术产业,
           TXGJSZZYDLMC,    --14 投向高技术制造业大类,
           GJSCYMC,         --15 高技术产业名称,
           SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
           ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
           TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
           SZJJHXCYMC,      --19 数字经济核心产业名称,
           TXZLXXXCYML,     --20 投向战略性新兴产业门类,
           ZYXXXCYMC,       --21 战略性新兴产业名称,
           SFTXWHCYDL,      --22 是否投向文化产业大类,
           WHCYMC,          --23 文化产业名称,
           SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
           SFYSHZ,          --25 是否银税合作,
           SFNYCYHLTQY,     --26 是否农业产业化龙头企业
           SFYQ,            --27 是否延期,
           SYS_SOURCE,      --28 来源系统,
           SFGXRBZ,         --29 是否关系人保证,
           KHZBKHJLKHH,     --30 客户主办客户经理客户号,
           KHZBGYH,         --31 客户主办柜员号,
           KHZBKHJLMC,      --32 客户主办客户经理名称,
           KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
           JJZBKHJLH,       --34 借据主办客户经理号,
           JJZBGYH,         --35 借据主办柜员号,
           JJZBKHJLMC,      --36 借据主办客户经理名称,
           JJZBKHJLSSJG,    --37 借据主办客户经理所属机构
           SFWJY,           --38 是否玩具业
           WJHYMC,          --39 玩具业行业名称
           SFZFZDXM,        --40 是否政府重点项目
           SFSQQY,          --41 是否涉侨企业
           GYLRZQY,         --42 供应链融资企业
           SFTXHSFDCY,      --43 是否投向海上风电产业
           SFTXXXCNCY,      --44 是否投向新型储能产业
           SFZJTXZXQY,      --45 是否专精特新中小企业
           SFJGMDZDZJTXZXQY, --46 是否监管名单中的专精特新中小企业
           SFYLCY,           --47 是否养老产业
           SFTXZFHSHZBHZ_PPP_XM, --48 是否投向政府和社会资本合作（PPP）项目
           SFXJZFFDK,         --49 是否新机制发放贷款
           SFYZLLDLYQWJFXM,   --50 是否因资金链断裂导致的逾期未交付项目
           SFYZLLDLYQWJFXMKFRZ,--51 是否因资金链断裂导致的逾期未交付项目_开发融资
           SFYZLLDLYQWJFXMKFRZDK--52 是否因资金链断裂导致的逾期未交付项目_开发融资_贷款
      FROM RRP_MDL.ADD_DG_003_MONEY T1
     WHERE T1.DATA_DATE = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD') --取前一天数据
       AND NOT EXISTS (SELECT 1
                         FROM RRP_MDL.ADD_DG_003_MONEY_L T2
                        WHERE T1.JYWYM = T2.JYWYM
                          AND T2.DATA_DATE = V_P_DATE)
    ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 支持重跑 --
  V_STEP      := 3;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  --DELETE FROM ADD_DG_003_MONEY T WHERE T.DATA_DATE = V_P_DATE;--普通表的重跑处理
  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);--增加当天跑批分区

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序业务逻辑处理主体部分 --
  V_STEP      := 4;
  V_STEP_DESC := '处理数据-插入临时表-对公';
  V_STARTTIME := SYSDATE;

 /*********************插入临时表-对公***********************/
  INSERT INTO TMP_ADD_DG_003_MONEY NOLOGGING
    (  DATA_DATE,       --01 数据日期,
       ACCT_ORG_NUM,    --02 账务机构编号,
       JYWYM,           --03 交易唯一码,
       ZHWYM,           --04 账户唯一码,
       KHWYM,           --05 客户唯一码,
       KHMC,            --06 客户名称,
       PJBH,            --07 票据编号,
       JBJGMC,          --08 经办机构名称,
       JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
       ZWJGMC,          --10 账务机构名称,
       ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
       TXGTJCYML,       --12 投向高技术产业门类,
       SFTXGJSCY,       --13 是否投向高技术产业,
       TXGJSZZYDLMC,    --14 投向高技术制造业大类,
       GJSCYMC,         --15 高技术产业名称,
       SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
       ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
       TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
       SZJJHXCYMC,      --19 数字经济核心产业名称,
       TXZLXXXCYML,     --20 投向战略性新兴产业门类,
       ZYXXXCYMC,       --21 战略性新兴产业名称,
       SFTXWHCYDL,      --22 是否投向文化产业大类,
       WHCYMC,          --23 文化产业名称,
       SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
       SFYSHZ,          --25 是否银税合作,
       SFNYCYHLTQY,     --26 是否农业产业化龙头企业
       SFYQ,            --27 是否延期,
       SYS_SOURCE,      --28 来源系统,
       SFGXRBZ,         --29 是否关系人保证,
       KHZBKHJLKHH,     --30 客户主办客户经理客户号,
       KHZBGYH,         --31 客户主办柜员号,
       KHZBKHJLMC,      --32 客户主办客户经理名称,
       KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
       JJZBKHJLH,       --34 借据主办客户经理号,
       JJZBGYH,         --35 借据主办柜员号,
       JJZBKHJLMC,      --36 借据主办客户经理名称,
       JJZBKHJLSSJG,    --37 借据主办客户经理所属机构
       LOAN_ACCT_BAL,   --38 贷款余额
       DRAWDOWN_DT,     --39 放款日期
       SFWJY,           --40 是否玩具业
       WJHYMC,          --41 玩具业行业名称
       SFZFZDXM,        --42 是否政府重点项目
       SFSQQY,          --43 是否涉侨企业
       GYLRZQY,         --44 供应链融资企业
       SFTXHSFDCY,      --45 是否投向海上风电产业
       SFTXXXCNCY,      --46 是否投向新型储能产业
       SFZJTXZXQY,      --47 是否专精特新中小企业
       SFJGMDZDZJTXZXQY, --48 是否监管名单中的专精特新中小企业
       SFYLCY,           --49 是否养老产业
       SFTXZFHSHZBHZ_PPP_XM, --50 是否投向政府和社会资本合作（PPP）项目
       SFXJZFFDK         --51 是否新机制发放贷款
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE                          AS DATA_DATE         --01 数据日期
          ,NVL(TRIM(T1.ACCT_INSTIT_ID),'000000')                 AS ACCT_ORG_NUM      --02 账务机构编号
          ,T1.DUBIL_NUM                      AS JYWYM             --03 交易唯一码
          ,T1.CONT_ID                        AS ZHWYM             --04 账户唯一码
          ,CASE WHEN T2.STD_PROD_ID IN ('203020300002','203030600002') THEN A8.LC_BENEFC --穿透后客户号
             ELSE T1.CUST_ID  END                        AS KHWYM             --05 客户唯一码
          ,T4.CUST_NAME                      AS KHMC              --06 客户名称
          ,NULL                              AS PJBH              --07 票据编号     对公无票据
          ,T5.ORG_NAME                       AS JBJGMC            --08 经办机构名称
          ,NVL(TRIM(T5.CITY_CD), '440000')   AS JBJGJGSZXZQHDM    --09 经办机构机构所在行政区划代码
          ,T6.ORG_NAME                       AS ZWJGMC            --10 账务机构名称
          ,NVL(TRIM(T6.CITY_CD), '440000')   AS ZWJGJGSZXZQHDM    --11 账务机构机构所在行政区划代码
          ,CASE WHEN T8.SFDX = 'Y'
                THEN ''
                WHEN T8.CODE IS NOT NULL
                THEN T8.CYML
                ELSE NULL
           END                               AS TXGTJCYML         --12 投向高技术产业门类
          ,CASE WHEN D.HIGH_TECH_PROPERTY_FLG = '1'
                THEN 'Y'
                ELSE 'N'
           END                               AS SFTXGJSCY         --13 是否投向高技术产业 --调整为信贷标志出数 20240619
          ,CASE WHEN T8.CYML = '制造业'
                THEN T8.L_NAME
                WHEN T8.SFDX = 'Y'
                THEN ''
                WHEN T8.CODE IS NOT NULL
                THEN T8.L_NAME
                ELSE NULL
           END                              AS TXGJSZZYDLMC      --14 投向高技术制造业大类
          ,CASE WHEN T8.SFDX = 'Y'
                THEN T8.NAME||'*'
                WHEN T8.CODE IS NOT NULL
                THEN T8.NAME
                ELSE NULL
           END                               AS GJSCYMC           --15 高技术产业名称
          ,CASE WHEN T9.SFDX = 'Y'
                THEN ''
                WHEN T9.CODE IS NOT NULL
                THEN 'Y'
                ELSE 'N'
           END                               AS SFTXZSCQMJXCY     --16 是否投向知识产权密集型产业
          ,CASE WHEN T9.SFDX = 'Y'
                THEN T9.NAME||'*'
                WHEN T9.CODE IS NOT NULL
                THEN T9.NAME
                ELSE NULL
           END                               AS ZSCQMJXCYMC       --17 知识产权密集型产业名称
          ,CASE SUBSTR(REPLACE(NVL(TRIM(D.DIGIT_ECON_CORE_TYPE_CD),'06'),'999999','06'),1,2)
               WHEN '01' THEN '01' --数字产品制造业
               WHEN '02' THEN '02' --数字产品服务业
               WHEN '03' THEN '03' --数字技术应用业
               WHEN '04' THEN '04' --数字要素驱动业
               WHEN '05' THEN '05' --数字化效率提升业
               WHEN '06' THEN '06' --非数据经济核心产业
               ELSE '06' --非数据经济核心产业 --调整为信贷标志出数 20240619
           END                              AS TXSZJJHXCYDL      --18 投向数字经济核心产业大类
          ,CASE SUBSTR(REPLACE(NVL(TRIM(D.DIGIT_ECON_CORE_TYPE_CD),'06'),'999999','06'),1,2)
               WHEN '01' THEN '数字产品制造业' --数字产品制造业
               WHEN '02' THEN '数字产品服务业' --数字产品服务业
               WHEN '03' THEN '数字技术应用业' --数字技术应用业
               WHEN '04' THEN '数字要素驱动业' --数字要素驱动业
               WHEN '05' THEN '数字化效率提升业' --数字化效率提升业
               WHEN '06' THEN '非数据经济核心产业' --非数据经济核心产业
               ELSE '非数据经济核心产业' --非数据经济核心产业 --调整为信贷标志出数 20240619
           END                              AS SZJJHXCYMC        --19 数字经济核心产业名称
          ,CASE SUBSTR(REPLACE(NVL(TRIM(D.STRATE_NEW_INDUS_TYPE_CD),'0'),'999999','0'),1,1)
                  WHEN '7' THEN 'C' --节能环保
                  WHEN '1' THEN 'D' --新一代信息技术
                  WHEN '4' THEN 'E' --生物医药
                  WHEN '2' THEN 'F' --高端装备制造
                  WHEN '6' THEN 'G' --新能源
                  WHEN '3' THEN 'H' --新材料
                  WHEN '5' THEN 'I' --新能源汽车
                  WHEN '8' THEN 'J' --数字创意产业
                  WHEN '9' THEN 'K' --相关服务业
           ELSE 'NA' END                     AS TXZLXXXCYML       --20 投向战略性新兴产业门类 --调整为信贷标志出数 20240619
          ,CASE SUBSTR(REPLACE(NVL(TRIM(D.STRATE_NEW_INDUS_TYPE_CD),'0'),'999999','0'),1,1)
                  WHEN '7' THEN '节能环保产业' --节能环保
                  WHEN '1' THEN '新一代信息技术产业' --新一代信息技术
                  WHEN '4' THEN '生物产业' --生物医药
                  WHEN '2' THEN '高端装备制造产业' --高端装备制造
                  WHEN '6' THEN '新能源产业' --新能源
                  WHEN '3' THEN '新材料产业' --新材料
                  WHEN '5' THEN '新能源汽车产业' --新能源汽车
                  WHEN '8' THEN '数字创意产业' --数字创意产业
                  WHEN '9' THEN '相关服务业' --相关服务业
           ELSE '不适用' END                              AS ZYXXXCYMC         --21 战略性新兴产业名称
          ,CASE WHEN D.CUL_PROPERTY_FLG = '1'
                THEN 'Y'
                ELSE 'N'
            END                              AS SFTXWHCYDL        --22 是否投向文化产业大类 --调整为信贷标志出数 20240619
          ,CASE WHEN T12.SFDX = 'Y'
                THEN T12.NAME||'*'
                WHEN T12.CODE IS NOT NULL
                THEN T12.NAME
                ELSE NULL
            END                              AS WHCYMC            --23 文化产业名称
          ,DECODE(D.INDU_CORP_TECH_REM_UGD_FLG,'1','Y','N')
                                             AS SFGYQYJSGZSJDK    --24 是否工业企业技术改造升级贷款 --调整为信贷标志出数 20240619
          ,'N'                               AS SFYSHZ            --25 是否银税合作
          ,NULL                              AS SFNYCYHLTQY       --26 是否农业产业化龙头企业          补录字段，可置空，继承上一天数据
          ,'N'                               AS SFYQ              --27 是否延期
          ,'对公'                            AS SYS_SOURCE        --28 来源系统
          ,DECODE(D.RELA_PEOP_GUAR_LOAN_FLG,'1','Y','N')
                                                    AS SFGXRBZ           --29 是否关系人保证
          ,T4.CUST_MGR_ID                           AS KHZBKHJLKHH       --30 客户主办客户经理客户号
          ,T16.TELLER_ID                            AS KHZBGYH           --31 客户主办柜员号
          ,NVL(T17.TELLER_NAME,T16.CLERK_NAME)      AS KHZBKHJLMC        --32 客户主办客户经理名称
          ,NVL(T17.BELONG_ORG_ID,T16.BELONG_ORG_ID) AS KHZBKHJLSSJG      --33 客户主办客户经理所属机构
          ,T18.CLERK_ID                             AS JJZBKHJLH         --34 借据主办客户经理号
          ,T2.RGST_TELLER_ID                        AS JJZBGYH           --35 借据主办柜员号
          ,NVL(T19.TELLER_NAME, T18.CLERK_NAME)     AS JJZBKHJLMC        --36 借据主办客户经理名称
          ,NVL(T19.BELONG_ORG_ID,T18.BELONG_ORG_ID) AS JJZBKHJLSSJG      --37 借据主办客户经理所属机构
          ,CASE WHEN T1.WRT_OFF_FLG = '1' THEN 0
                WHEN T1.WRT_OFF_FLG <> '1' THEN
                CASE WHEN T1.SUBJ_ID LIKE '1313%' THEN NVL(T1.OVDUE_PRIC_BAL, 0) + NVL(T1.IDLE_PRIC, 0) + NVL(T1.BAD_DEBT_PRIC, 0)
                     WHEN T1.SUBJ_ID IN ('30070102') THEN NVL(T1.PRIC_BAL,0) - NVL(T1.WRT_OFF_PRIC, 0)
                     WHEN T2.STD_PROD_ID IN ('203040600001') AND T1.SUBJ_ID IN( '13050201%')
                     THEN ROUND((NVL(T1.PRIC_BAL, 0) - NVL(T1.WRT_OFF_PRIC, 0) + NVL(T14.N_PV_VARIATION, 0) - NVL(T1.IN_BS_INT, 0)),2)
                     WHEN T2.STD_PROD_ID IN('203020300002','203030600002')
                     THEN ROUND((NVL(T1.PRIC_BAL, 0) - NVL(T1.WRT_OFF_PRIC, 0) + NVL(T14.N_PV_VARIATION, 0) - NVL(T1.IN_BS_INT, 0)),2)
                ELSE NVL(T1.PRIC_BAL, 0) - NVL(T1.WRT_OFF_PRIC, 0) END
           END                                       AS LOAN_ACCT_BAL     --38 贷款余额
          ,T1.DISTR_DT                               AS DRAWDOWN_DT       --39 放款日期
          ,CASE WHEN SUBSTR(T2.DIR_INDUS_CD,0,4) = 'C245' THEN 'Y'
                WHEN T2.DIR_INDUS_CD IN ('F5149','F5249') THEN 'Y'
           ELSE '' END                               AS SFWJY             --40 是否玩具业
          ,CASE WHEN SUBSTR(T2.DIR_INDUS_CD,0,4) = 'C245' THEN P.SRC_VALUE_NAME
                WHEN T2.DIR_INDUS_CD IN ('F5149','F5249') THEN P.SRC_VALUE_NAME||'*'
           ELSE '' END                               AS WJHYMC            --41 玩具业行业名称
          ,''                                        AS SFZFZDXM          --42 是否政府重点项目
          ,''                                        AS SFSQQY            --43 是否涉侨企业
          ,''                                        AS GYLRZQY           --44 供应链融资企业
          ,CASE WHEN T2.DIR_INDUS_CD = 'C3462' THEN 'Y'
           END                                       AS SFTXHSFDCY        --45 是否投向海上风电产业
          ,''                                        AS SFTXHSFDCY        --46 是否投向海上风电产业
          ,CASE WHEN C.SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG = '1' THEN 'Y'
                ELSE 'N'
                END                                  AS SFZJTXZXQY        --47 是否专精特新中小企业    --MODIFY BY YJY IN 20240220
          ,''                                        AS SFJGMDZDZJTXZXQY  --48 是否监管名单中的专精特新中小企业
          ,DECODE(D.PROVI_FOR_AGED_PROPERTY_FLG,'1','Y','N')
                                                     AS SFYLCY            --49 是否养老产业 --调整为信贷标志出数 20240619
          ,DECODE(D.PPP_PROJ_FLG,'1','Y','N')
                                                     AS SFTXZFHSHZBHZ_PPP_XM --50 是否投向政府和社会资本合作（PPP）项目 --调整为信贷标志出数 20240619
          ,DECODE(D.NEW_DISTR_FLG,'1','Y','N')
                                                     AS SFXJZFFDK         --51 是否新机制发放贷款 --调整为信贷标志出数 20240619
      FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO T1    --对公贷款账户信息
     INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T2 --对公贷款借据信息表 -- 以账户为主表关联
             ON T2.DUBIL_ID = T1.DUBIL_NUM
            AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T3  --对公贷款合同信息表
             ON T2.CONT_ID = T3.CONT_ID
            AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO D --对公贷款业务合同附加信息 add by hulj20240131
            ON D.CONT_ID = T3.CONT_ID
           AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     --不从信贷取专精特新中小企业标志，改从ECIF取专精特新中小企业标志
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_ATTACH_INFO C  --对公客户补充信息 MODIFY BY YJY 20240220
             ON T1.CUST_ID = C.CUST_ID
            AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H A8   --贷款出账对公贷款附属信息历史add by hulj20230728
             ON A8.OUT_ACCT_FLOW_NUM = T2.OUT_ACCT_FLOW_NUM  --取穿透后二级福费廷客户号 modify by lwb
            AND A8.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
            AND A8.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T4  --对公客户基本信息表
             ON (CASE WHEN T2.STD_PROD_ID IN ('203020300002','203030600002') THEN A8.LC_BENEFC --穿透后客户号
             ELSE T1.CUST_ID  END) = T4.CUST_ID
            AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T5 --内部机构信息表
             ON T1.MGMT_ORG_ID = T5.ORG_ID --管理机构
            AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T6 --内部机构信息表
             ON T1.ACCT_INSTIT_ID = T6.ORG_ID --财务机构
            AND T6.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN (SELECT DISTINCT CODE,NAME,SFDX,CYML,L_NAME FROM M_DICT_G0107_REMAPPING_BL WHERE TYPE_CODE = 'G010701') T8 --高技术产业
             ON T2.DIR_INDUS_CD = T8.CODE
      LEFT JOIN (SELECT DISTINCT CODE,NAME,SFDX FROM M_DICT_G0107_REMAPPING_BL WHERE TYPE_CODE = 'G010703') T9--知识产权密集型产业
             ON T2.DIR_INDUS_CD = T9.CODE
      LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.CODE ORDER BY T.S_CORE) RN FROM M_DICT_G0107_REMAPPING_BL T WHERE TYPE_CODE = 'G010702') T10--数字经济核心产业
             ON T2.DIR_INDUS_CD = T10.CODE
            AND T10.RN = 1
      LEFT JOIN  M_INDUSTRY_CLASSIFY T11
             ON T2.DIR_INDUS_CD = T11.INDUS_CATE_CD
            AND T11.CLASSIFY = '战略新兴'
      LEFT JOIN  (SELECT DISTINCT CYML,CODE,NAME,SFDX,SFDZBSY FROM M_DICT_G19_REMAPPING_BL WHERE TYPE_CODE = 'G1902' AND SFDZBSY = 'N') T11_1
             ON T2.DIR_INDUS_CD = T11_1.CODE
      LEFT JOIN  (SELECT DISTINCT CODE,NAME,SFDX,SFDZBSY FROM M_DICT_G19_REMAPPING_BL WHERE TYPE_CODE = 'G1902' AND SFDZBSY = 'Y') T11_2
             ON T2.DIR_INDUS_CD = T11_2.CODE
      LEFT JOIN (SELECT DISTINCT CODE,NAME,S_CORE,S_NAME,SFDX FROM M_DICT_G19_REMAPPING_BL WHERE TYPE_CODE = 'G1901') T12 --文化及相关产业
             ON T2.DIR_INDUS_CD = T12.CODE
      LEFT JOIN RRP_MDL.O_ICL_CMM_GUAR_CONT T13 --担保合同表
             ON T3.CONT_ID = T13.GUAR_CONT_ID
            AND T13.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE T14  --估值报告表  关联估值表取 国内信用证福费廷 公允价值变动
             ON T1.DUBIL_NUM = T14.V_TRADE_NO
            AND T14.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      /*LEFT JOIN M_BUSINESS_TYPE T15
        ON T2.BUS_BREED_ID = T15.BUS_BREED_ID
       AND T15.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_IOL_CRSS_BUSINESS_CONTRACT T32 --业务合同信息
        ON T3.CONT_ID = T32.SERIALNO
       AND T32.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/
      LEFT JOIN RRP_MDL.O_ICL_CMM_CLERK_INFO T16
             ON T4.CUST_MGR_ID = T16.CLERK_ID
            AND T16.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_TELLER_INFO T17
             ON T16.TELLER_ID = T17.TELLER_ID
            AND T17.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.TELLER_ID ORDER BY T.DIMISSION_DT DESC) RN
                  FROM RRP_MDL.O_ICL_CMM_CLERK_INFO T
                 WHERE T.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
                   AND T.TELLER_ID IS NOT NULL
                ) T18
             ON T2.RGST_TELLER_ID = T18.TELLER_ID
            AND T18.RN = 1
      LEFT JOIN RRP_MDL.O_ICL_CMM_TELLER_INFO T19
             ON T2.RGST_TELLER_ID = T19.TELLER_ID
            AND T19.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN RRP_MDL.CODE_MAP P
             ON T2.DIR_INDUS_CD = P.SRC_VALUE_CODE
            AND P.SRC_CLASS_CODE = 'P0003'
            AND P.TAR_CLASS_CODE = 'P0003'
            AND P.MOD_FLG = 'MDM'
     WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       --剔除委托贷款
       AND (T2.STD_PROD_ID LIKE '203%' OR T2.STD_PROD_ID LIKE '204%')
       --AND (T2.STD_PROD_ID LIKE '2%' OR T2.STD_PROD_ID IS NULL OR T2.STD_PROD_ID IN ('203040600001','203020300002','203030600001','203030600002')
         --OR T3.STD_PROD_ID LIKE '2%'  OR T3.STD_PROD_ID IS NULL OR T3.STD_PROD_ID IN ('203040600001','203020300002','203030600001','203030600002'))
       AND (T3.CRDT_TYPE_CD = '02' OR T3.CRDT_TYPE_CD IS NULL ) --00未知 01额度合同  02业务合同
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    /**************插入临时表-贴现****************/
  V_STEP      := 5;
  V_STEP_DESC := '处理数据-插入临时表-贴现';
  V_STARTTIME := SYSDATE;

   INSERT INTO TMP_ADD_DG_003_MONEY NOLOGGING
    (  DATA_DATE,       --01 数据日期,
       ACCT_ORG_NUM,    --02 账务机构编号,
       JYWYM,           --03 交易唯一码,
       ZHWYM,           --04 账户唯一码,
       KHWYM,           --05 客户唯一码,
       KHMC,            --06 客户名称,
       PJBH,            --07 票据编号,
       JBJGMC,          --08 经办机构名称,
       JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
       ZWJGMC,          --10 账务机构名称,
       ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
       TXGTJCYML,       --12 投向高技术产业门类,
       SFTXGJSCY,       --13 是否投向高技术产业,
       TXGJSZZYDLMC,    --14 投向高技术制造业大类,
       GJSCYMC,         --15 高技术产业名称,
       SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
       ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
       TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
       SZJJHXCYMC,      --19 数字经济核心产业名称,
       TXZLXXXCYML,     --20 投向战略性新兴产业门类,
       ZYXXXCYMC,       --21 战略性新兴产业名称,
       SFTXWHCYDL,      --22 是否投向文化产业大类,
       WHCYMC,          --23 文化产业名称,
       SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
       SFYSHZ,          --25 是否银税合作,
       SFNYCYHLTQY,     --26 是否农业产业化龙头企业
       SFYQ,            --27 是否延期,
       SYS_SOURCE,      --28 来源系统,
       SFGXRBZ,         --29 是否关系人保证,
       KHZBKHJLKHH,     --30 客户主办客户经理客户号,
       KHZBGYH,         --31 客户主办柜员号,
       KHZBKHJLMC,      --32 客户主办客户经理名称,
       KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
       JJZBKHJLH,       --34 借据主办客户经理号,
       JJZBGYH,         --35 借据主办柜员号,
       JJZBKHJLMC,      --36 借据主办客户经理名称,
       JJZBKHJLSSJG,    --37 借据主办客户经理所属机构
       LOAN_ACCT_BAL,   --38 贷款余额
       DRAWDOWN_DT,     --39 放款日期
       SFWJY,           --40 是否玩具业
       WJHYMC,          --41 玩具业行业名称
       SFZFZDXM,        --42 是否政府重点项目
       SFSQQY,          --43 是否涉侨企业
       GYLRZQY,         --44 供应链融资企业
       SFTXHSFDCY,      --45 是否投向海上风电产业
       SFTXXXCNCY,      --46 是否投向新型储能产业
       SFZJTXZXQY,      --47 是否专精特新中小企业
       SFJGMDZDZJTXZXQY, --48 是否监管名单中的专精特新中小企业
       SFYLCY,           --49 是否养老产业
       SFTXZFHSHZBHZ_PPP_XM, --50 是否投向政府和社会资本合作（PPP）项目
       SFXJZFFDK         --51 是否新机制发放贷款
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE                          AS DATA_DATE         --01 数据日期
          ,/*NVL(TRIM(T2.ACCT_INSTIT_ID),'000000') */
           T1.ENTER_ACCT_ORG_ID  --mod by liuyu 20230601
                                             AS ACCT_ORG_NUM      --02 账务机构编号
          ,T2.DUBIL_ID                       AS JYWYM             --03 交易唯一码
          ,T2.CONT_ID                        AS ZHWYM             --04 账户唯一码
          ,T2.CUST_ID                        AS KHWYM             --05 客户唯一码
          ,T4.CUST_NAME                      AS KHMC              --06 客户名称
          ,T2.BILL_NUM                       AS PJBH              --07 票据编号
          ,T5.ORG_NAME                       AS JBJGMC            --08 经办机构名称
          ,NVL(TRIM(T5.CITY_CD), '440000')   AS JBJGJGSZXZQHDM    --09 经办机构机构所在行政区划代码
          ,T5.ORG_NAME                       AS ZWJGMC            --10 账务机构名称
          ,NVL(TRIM(T5.CITY_CD), '440000')   AS ZWJGJGSZXZQHDM    --11 账务机构机构所在行政区划代码
          /*,NVL(T15.BUS_BREED_NAME,T2.BUS_BREED_ID)
                                             AS DKPZMC            --09 贷款品种名称*/
          --,T2.STD_PROD_ID                    AS DKPZMC            --09 贷款品种名称
          ,NULL                              AS TXGTJCYML         --12 投向高技术产业门类
          ,CASE WHEN D.HIGH_TECH_PROPERTY_FLG = '1'
                THEN 'Y'
                ELSE 'N'
           END                               AS SFTXGJSCY         --13 是否投向高技术产业
          ,CASE WHEN T8.CYML = '制造业'
                THEN T8.L_NAME
                WHEN T8.SFDX = 'Y'
                THEN ''
                WHEN T8.CODE IS NOT NULL
                THEN T8.L_NAME
                ELSE NULL
           END                               AS TXGJSZZYDLMC      --14 投向高技术制造业大类
          ,CASE WHEN T8.SFDX = 'Y'
                THEN T8.NAME||'*'
                WHEN T8.CODE IS NOT NULL
                THEN T8.NAME
                ELSE NULL
           END                               AS GJSCYMC           --15 高技术产业名称
          ,CASE WHEN T9.SFDX = 'Y'
                THEN ''
                WHEN T9.CODE IS NOT NULL
                THEN 'Y'
                ELSE 'N'
           END                               AS SFTXZSCQMJXCY     --16 是否投向知识产权密集型产业
          ,CASE WHEN T9.SFDX = 'Y'
                THEN T9.NAME||'*'
                WHEN T9.CODE IS NOT NULL
                THEN T9.NAME
                ELSE NULL
           END                               AS ZSCQMJXCYMC       --17 知识产权密集型产业名称
          ,CASE SUBSTR(REPLACE(NVL(TRIM(D.DIGIT_ECON_CORE_TYPE_CD),'06'),'999999','06'),1,2)
               WHEN '01' THEN '01' --数字产品制造业
               WHEN '02' THEN '02' --数字产品服务业
               WHEN '03' THEN '03' --数字技术应用业
               WHEN '04' THEN '04' --数字要素驱动业
               WHEN '05' THEN '05' --数字化效率提升业
               WHEN '06' THEN '06' --非数据经济核心产业
               ELSE '06' --非数据经济核心产业 --调整为信贷标志出数 20240624
           END                              AS TXSZJJHXCYDL      --18 投向数字经济核心产业大类
          ,CASE SUBSTR(REPLACE(NVL(TRIM(D.DIGIT_ECON_CORE_TYPE_CD),'06'),'999999','06'),1,2)
               WHEN '01' THEN '数字产品制造业' --数字产品制造业
               WHEN '02' THEN '数字产品服务业' --数字产品服务业
               WHEN '03' THEN '数字技术应用业' --数字技术应用业
               WHEN '04' THEN '数字要素驱动业' --数字要素驱动业
               WHEN '05' THEN '数字化效率提升业' --数字化效率提升业
               WHEN '06' THEN '非数据经济核心产业' --非数据经济核心产业
               ELSE '非数据经济核心产业' --非数据经济核心产业 --调整为信贷标志出数 20240624
           END                              AS SZJJHXCYMC        --19 数字经济核心产业名称
          ,CASE SUBSTR(REPLACE(NVL(TRIM(D.STRATE_NEW_INDUS_TYPE_CD),'0'),'999999','0'),1,1)
                  WHEN '7' THEN 'C' --节能环保
                  WHEN '1' THEN 'D' --新一代信息技术
                  WHEN '4' THEN 'E' --生物医药
                  WHEN '2' THEN 'F' --高端装备制造
                  WHEN '6' THEN 'G' --新能源
                  WHEN '3' THEN 'H' --新材料
                  WHEN '5' THEN 'I' --新能源汽车
                  WHEN '8' THEN 'J' --数字创意产业
                  WHEN '9' THEN 'K' --相关服务业
           ELSE 'NA' END                     AS TXZLXXXCYML       --20 投向战略性新兴产业门类 --调整为信贷标志出数 20240624
          ,CASE SUBSTR(REPLACE(NVL(TRIM(D.STRATE_NEW_INDUS_TYPE_CD),'0'),'999999','0'),1,1)
                  WHEN '7' THEN '节能环保产业' --节能环保
                  WHEN '1' THEN '新一代信息技术产业' --新一代信息技术
                  WHEN '4' THEN '生物产业' --生物医药
                  WHEN '2' THEN '高端装备制造产业' --高端装备制造
                  WHEN '6' THEN '新能源产业' --新能源
                  WHEN '3' THEN '新材料产业' --新材料
                  WHEN '5' THEN '新能源汽车产业' --新能源汽车
                  WHEN '8' THEN '数字创意产业' --数字创意产业
                  WHEN '9' THEN '相关服务业' --相关服务业
           ELSE '不适用' END                      AS ZYXXXCYMC         --21 战略性新兴产业名称
          ,CASE WHEN D.CUL_PROPERTY_FLG = '1'
                THEN 'Y'
                ELSE 'N'
            END                              AS SFTXWHCYDL        --22 是否投向文化产业大类
          ,CASE WHEN T12.SFDX = 'Y'
                THEN T12.NAME||'*'
                WHEN T12.CODE IS NOT NULL
                THEN T12.NAME
                ELSE ''
            END                              AS WHCYMC            --23 文化产业名称
          ,DECODE(D.INDU_CORP_TECH_REM_UGD_FLG,'1','Y','N')
                                             AS SFGYQYJSGZSJDK    --24 是否工业企业技术改造升级贷款
          ,'N'                               AS SFYSHZ            --25 是否银税合作
          ,NULL                              AS SFNYCYHLTQY       --26 是否农业产业化龙头企业          补录字段，可置空，继承上一天数据
          ,'N'                               AS SFYQ              --27 是否延期
          ,'贴现'                            AS SYS_SOURCE        --28 来源系统
          ,DECODE(D.RELA_PEOP_GUAR_LOAN_FLG,'1','Y','N')
                                                    AS SFGXRBZ           --29 是否关系人保证
          ,T4.CUST_MGR_ID                           AS KHZBKHJLKHH       --30 客户主办客户经理客户号
          ,T16.TELLER_ID                            AS KHZBGYH           --31 客户主办柜员号
          ,NVL(T17.TELLER_NAME,T16.CLERK_NAME)      AS KHZBKHJLMC        --32 客户主办客户经理名称
          ,NVL(T17.BELONG_ORG_ID,T16.BELONG_ORG_ID) AS KHZBKHJLSSJG      --33 客户主办客户经理所属机构
          ,T18.CLERK_ID                             AS JJZBKHJLH         --34 借据主办客户经理号
          ,T2.RGST_TELLER_ID                        AS JJZBGYH           --35 借据主办柜员号
          ,NVL(T19.TELLER_NAME, T18.CLERK_NAME)     AS JJZBKHJLMC        --36 借据主办客户经理名称
          ,NVL(T19.BELONG_ORG_ID,T18.BELONG_ORG_ID) AS JJZBKHJLSSJG      --37 借据主办客户经理所属机构
          ,CASE WHEN T2.PAYOFF_DT >= TO_DATE(V_P_DATE, 'YYYYMMDD')
                THEN ROUND((NVL(T1.CURRT_BAL, 0) - NVL(T1.INT_ADJ_BAL, 0) + NVL(T13.N_PV_VARIATION, 0)),2) -- 公允价值四舍五入取小数点后两位
           ELSE 0 END                               AS LOAN_ACCT_BAL     --38 贷款余额
          ,T2.DISTR_DT                              AS DRAWDOWN_DT       --39 放款日期
          ,CASE WHEN SUBSTR(T2.DIR_INDUS_CD,0,4) = 'C245' THEN 'Y'
                WHEN T2.DIR_INDUS_CD IN ('F5149','F5249') THEN 'Y'
           ELSE '' END                               AS SFWJY             --40 是否玩具业
          ,CASE WHEN SUBSTR(T2.DIR_INDUS_CD,0,4) = 'C245' THEN P.SRC_VALUE_NAME
                WHEN T2.DIR_INDUS_CD IN ('F5149','F5249') THEN P.SRC_VALUE_NAME||'*'
           ELSE '' END                               AS WJHYMC            --41 玩具业行业名称
          ,''                                        AS SFZFZDXM          --42 是否政府重点项目
          ,''                                        AS SFSQQY            --43 是否涉侨企业
          ,''                                        AS GYLRZQY           --44 供应链融资企业
          ,CASE WHEN T2.DIR_INDUS_CD = 'C3462' THEN 'Y'
           END                                       AS SFTXHSFDCY        --45 是否投向海上风电产业
          ,''                                        AS SFTXHSFDCY        --46 是否投向海上风电产业
          ,''                                        AS SFZJTXZXQY        --47 是否专精特新中小企业
          ,''                                        AS SFJGMDZDZJTXZXQY  --48 是否监管名单中的专精特新中小企业
          ,DECODE(D.PROVI_FOR_AGED_PROPERTY_FLG,'1','Y','N')
                                                     AS SFYLCY           --49 是否养老产业
          ,DECODE(D.PPP_PROJ_FLG,'1','Y','N')
                                                     AS SFTXZFHSHZBHZ_PPP_XM --50 是否投向政府和社会资本合作（PPP）项目
          ,DECODE(D.NEW_DISTR_FLG,'1','Y','N')
                                                     AS SFXJZFFDK         --51 是否新机制发放贷款
      FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO T1  -- 票据贴现信息
     INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T2 --对公贷款借据信息表
        ON T2.BILL_UNIQ_MARK_ID = NVL(TRIM(T1.BILL_ENTRY_ID),T1.BILL_ID)
       AND T2.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002')
       AND TRIM(T2.BILL_UNIQ_MARK_ID) IS NOT NULL
       AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T3  --对公贷款合同信息表
        ON T2.CONT_ID = T3.CONT_ID
       AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO D --对公贷款业务合同附加信息 add by hyf 20240624
            ON D.CONT_ID = T3.CONT_ID
           AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T4  --对公客户基本信息表
        ON T1.CUST_ID = T4.CUST_ID
       AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T5 --内部机构信息表
        ON T1.ENTER_ACCT_ORG_ID = T5.ORG_ID --
       AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN (SELECT DISTINCT CODE,NAME,SFDX,CYML,L_NAME FROM M_DICT_G0107_REMAPPING_BL WHERE TYPE_CODE = 'G010701') T8 --高技术产业
        ON T2.DIR_INDUS_CD = T8.CODE
      LEFT JOIN (SELECT DISTINCT CODE,NAME,SFDX FROM M_DICT_G0107_REMAPPING_BL WHERE TYPE_CODE = 'G010703') T9--知识产权密集型产业
        ON T2.DIR_INDUS_CD = T9.CODE
      LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.CODE ORDER BY T.S_CORE) RN FROM M_DICT_G0107_REMAPPING_BL T WHERE TYPE_CODE = 'G010702') T10--数字经济核心产业
        ON T2.DIR_INDUS_CD = T10.CODE
       AND T10.RN = 1
      LEFT JOIN  M_INDUSTRY_CLASSIFY T11
        ON T2.DIR_INDUS_CD = T11.INDUS_CATE_CD
       AND T11.CLASSIFY = '战略新兴'
      LEFT JOIN  (SELECT DISTINCT CYML,CODE,NAME,SFDX,SFDZBSY FROM M_DICT_G19_REMAPPING_BL WHERE TYPE_CODE = 'G1902' AND SFDZBSY = 'N') T11_1
        ON T2.DIR_INDUS_CD = T11_1.CODE
      LEFT JOIN  (SELECT DISTINCT CODE,NAME,SFDX,SFDZBSY FROM M_DICT_G19_REMAPPING_BL WHERE TYPE_CODE = 'G1902' AND SFDZBSY = 'Y') T11_2
        ON T2.DIR_INDUS_CD = T11_2.CODE
      LEFT JOIN (SELECT DISTINCT CODE,NAME,S_CORE,S_NAME,SFDX FROM M_DICT_G19_REMAPPING_BL WHERE TYPE_CODE = 'G1901') T12 --文化及相关产业
        ON T2.DIR_INDUS_CD = T12.CODE
      LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE T13 --估值报告表 关联估值表取 贴现 公允价值变动
        --ON T13.V_TRADE_NO = T1.BILL_NUM
        ON T13.V_TRADE_NO = T1.BILL_ID --新票据关联字段变更
       AND T13.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND T13.V_BUSINESSTYPE = T2.STD_PROD_ID
      LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO T15
        ON T2.STD_PROD_ID = T15.PROD_ID
       AND T15.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_GUAR_CONT T31 --担保合同表
        ON T3.CONT_ID = T31.GUAR_CONT_ID
       AND T31.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_CLERK_INFO T16
        ON T4.CUST_MGR_ID = T16.CLERK_ID
       AND T16.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_TELLER_INFO T17
        ON T16.TELLER_ID = T17.TELLER_ID
       AND T17.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.TELLER_ID ORDER BY T.DIMISSION_DT DESC) RN
                  FROM RRP_MDL.O_ICL_CMM_CLERK_INFO T
                 WHERE T.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
                   AND T.TELLER_ID IS NOT NULL
                ) T18
        ON T2.RGST_TELLER_ID = T18.TELLER_ID
       AND T18.RN = 1
      LEFT JOIN RRP_MDL.O_ICL_CMM_TELLER_INFO T19
        ON T2.RGST_TELLER_ID = T19.TELLER_ID
       AND T19.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN RRP_MDL.CODE_MAP P
             ON T2.DIR_INDUS_CD = P.SRC_VALUE_CODE
            AND P.SRC_CLASS_CODE = 'P0003'
            AND P.TAR_CLASS_CODE = 'P0003'
            AND P.MOD_FLG = 'MDM'
     WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      --AND T1.DISCNT_STATUS_CD NOT IN ('012','001')
      --AND T1.ENTRY_STATUS_CD = '3'
      --新票据码值变更
      AND T1.DISCNT_STATUS_CD NOT IN ('00','01','02')
      AND T1.ENTRY_STATUS_CD = '03'
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    /**************插入临时表-买断式转贴现****************/
  V_STEP      := 6;
  V_STEP_DESC := '插入临时表-买断式转贴现';
  V_STARTTIME := SYSDATE;

   INSERT INTO TMP_ADD_DG_003_MONEY
    (  DATA_DATE,       --01 数据日期,
       ACCT_ORG_NUM,    --02 账务机构编号,
       JYWYM,           --03 交易唯一码,
       ZHWYM,           --04 账户唯一码,
       KHWYM,           --05 客户唯一码,
       KHMC,            --06 客户名称,
       PJBH,            --07 票据编号,
       JBJGMC,          --08 经办机构名称,
       JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
       ZWJGMC,          --10 账务机构名称,
       ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
       TXGTJCYML,       --12 投向高技术产业门类,
       SFTXGJSCY,       --13 是否投向高技术产业,
       TXGJSZZYDLMC,    --14 投向高技术制造业大类,
       GJSCYMC,         --15 高技术产业名称,
       SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
       ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
       TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
       SZJJHXCYMC,      --19 数字经济核心产业名称,
       TXZLXXXCYML,     --20 投向战略性新兴产业门类,
       ZYXXXCYMC,       --21 战略性新兴产业名称,
       SFTXWHCYDL,      --22 是否投向文化产业大类,
       WHCYMC,          --23 文化产业名称,
       SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
       SFYSHZ,          --25 是否银税合作,
       SFNYCYHLTQY,     --26 是否农业产业化龙头企业
       SFYQ,            --27 是否延期,
       SYS_SOURCE,      --28 来源系统,
       SFGXRBZ,         --29 是否关系人保证,
       KHZBKHJLKHH,     --30 客户主办客户经理客户号,
       KHZBGYH,         --31 客户主办柜员号,
       KHZBKHJLMC,      --32 客户主办客户经理名称,
       KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
       JJZBKHJLH,       --34 借据主办客户经理号,
       JJZBGYH,         --35 借据主办柜员号,
       JJZBKHJLMC,      --36 借据主办客户经理名称,
       JJZBKHJLSSJG,    --37 借据主办客户经理所属机构
       LOAN_ACCT_BAL,   --38 贷款余额
       DRAWDOWN_DT,     --39 放款日期
       SFWJY,           --40 是否玩具业
       WJHYMC,          --41 玩具业行业名称
       SFZFZDXM,        --42 是否政府重点项目
       SFSQQY,          --43 是否涉侨企业
       GYLRZQY,         --44 供应链融资企业
       SFTXHSFDCY,      --45 是否投向海上风电产业
       SFTXXXCNCY,      --46 是否投向新型储能产业
       SFZJTXZXQY,      --47 是否专精特新中小企业
       SFJGMDZDZJTXZXQY, --48 是否监管名单中的专精特新中小企业
       SFYLCY,           --49 是否养老产业
       SFTXZFHSHZBHZ_PPP_XM, --50 是否投向政府和社会资本合作（PPP）项目
       SFXJZFFDK         --51 是否新机制发放贷款
    )
WITH TMP_ZTX AS (
SELECT B.DUBIL_ID ,A.BILL_NUM,A.BILL_SUB_INTRV_ID
FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_ID = A.BILL_ID
     AND B.STD_PROD_ID IN ('204010100001','204010100002') --20220924 MW 修改'204010100001' 银行承兑汇票转贴现 ‘204010100002’ 商业承兑汇票转贴现
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
 WHERE A.TRAN_DIR_CD = '01'      --MODIFY BY MW 20221207  上游码值变化
     AND A.BUS_TYPE_CD = 'BT01'    -- BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
     AND A.ENTRY_STATUS_CD = '03'  --筛选记账成功的票据
     AND A.SYS_IN_FLG='0'
     --AND A.CURRT_BAL <> 0
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     ),
   TMP_XTNZTX AS (
     SELECT C.DUBIL_ID ZTXJJ,T.*
     FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO A --票据贴现信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_UNIQ_MARK_ID = NVL(TRIM(A.BILL_ENTRY_ID),A.BILL_ID)
     AND B.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002')
     AND TRIM(B.BILL_UNIQ_MARK_ID) IS NOT NULL
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    INNER JOIN TMP_ZTX C
     ON C.BILL_NUM=A.BILL_NUM
    AND C.BILL_SUB_INTRV_ID=A.BILL_SUB_INTRV_ID
    INNER JOIN RRP_MDL.TMP_ADD_DG_003_MONEY T --补录表-对公-账务基表表
       ON B.DUBIL_ID = T.JYWYM
      AND T.DATA_DATE = V_P_DATE
     WHERE A.DISCNT_STATUS_CD IN ('06') --新一代取的为买入明细状态  06为记账完成 A.DISCNT_STATUS_CD NOT IN ('012','001')
     AND A.ENTRY_STATUS_CD = '03' --03 记账完成
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     )
    SELECT /*+ PARALLEL*/
           V_P_DATE                          AS DATA_DATE         --01 数据日期
          ,NVL(TRIM(T1.ACCT_INSTIT_ID),'000000')  -- mod by liuyu 20230601 调整取转贴现表机构号
                                             AS ACCT_ORG_NUM      --02 账务机构编号
          ,T2.DUBIL_ID                       AS JYWYM             --03 交易唯一码
          ,T2.CONT_ID                        AS ZHWYM             --04 账户唯一码
          ,T2.CUST_ID                        AS KHWYM             --05 客户唯一码
          ,T4.CUST_NAME                      AS KHMC              --06 客户名称
          ,T2.BILL_NUM                       AS PJBH              --07 票据编号
          ,T5.ORG_NAME                       AS JBJGMC            --08 经办机构名称
          ,NVL(TRIM(T5.CITY_CD), '440000')   AS JBJGJGSZXZQHDM    --09 经办机构机构所在行政区划代码
          ,T5.ORG_NAME                       AS ZWJGMC            --10 账务机构名称
          ,NVL(TRIM(T5.CITY_CD), '440000')   AS ZWJGJGSZXZQHDM    --11 账务机构机构所在行政区划代码
          ,CASE WHEN S.ZTXJJ IS NOT NULL THEN S.TXGTJCYML
           END                               AS TXGTJCYML         --12 投向高技术产业门类
          ,CASE WHEN S.ZTXJJ IS NOT NULL THEN S.SFTXGJSCY
                WHEN T8.SFDX = 'Y'
                THEN ''
                WHEN T8.CODE IS NOT NULL
                THEN 'Y'
                ELSE 'N'
           END                               AS SFTXGJSCY         --13 是否投向高技术产业
          ,CASE WHEN S.ZTXJJ IS NOT NULL THEN S.TXGJSZZYDLMC
                WHEN T8.CYML = '制造业'
                THEN T8.L_NAME
                WHEN T8.SFDX = 'Y'
                THEN ''
                WHEN T8.CODE IS NOT NULL
                THEN T8.L_NAME
                ELSE NULL
           END                               AS TXGJSZZYDLMC      --14 投向高技术制造业大类
          ,CASE WHEN S.ZTXJJ IS NOT NULL THEN S.GJSCYMC
                WHEN T8.SFDX = 'Y'
                THEN T8.NAME||'*'
                WHEN T8.CODE IS NOT NULL
                THEN T8.NAME
                ELSE NULL
           END                               AS GJSCYMC           --15 高技术产业名称
          ,CASE WHEN S.ZTXJJ IS NOT NULL THEN S.SFTXZSCQMJXCY
                WHEN T9.SFDX = 'Y'
                THEN ''
                WHEN T9.CODE IS NOT NULL
                THEN 'Y'
                ELSE 'N'
           END                               AS SFTXZSCQMJXCY     --16 是否投向知识产权密集型产业
          ,CASE WHEN S.ZTXJJ IS NOT NULL THEN S.ZSCQMJXCYMC
                WHEN T9.SFDX = 'Y'
                THEN T9.NAME||'*'
                WHEN T9.CODE IS NOT NULL
                THEN T9.NAME
                ELSE NULL
           END                               AS ZSCQMJXCYMC       --17 知识产权密集型产业名称
          ,CASE WHEN S.ZTXJJ IS NOT NULL THEN S.TXSZJJHXCYDL
                WHEN T10.SFDX = 'Y'
                THEN ''
                WHEN T10.CODE IS NOT NULL
                THEN T10.L_NAME
                ELSE ''
            END                              AS TXSZJJHXCYDL      --18 投向数字经济核心产业大类
          ,CASE WHEN S.ZTXJJ IS NOT NULL THEN S.SZJJHXCYMC
                WHEN T10.SFDX = 'Y'
                THEN T10.NAME||'*'
                WHEN T10.CODE IS NOT NULL
                THEN T10.NAME
                ELSE ''
            END                              AS SZJJHXCYMC        --19 数字经济核心产业名称
          ,CASE WHEN S.ZTXJJ IS NOT NULL THEN S.TXZLXXXCYML
           END                               AS TXZLXXXCYML       --20 投向战略性新兴产业门类
          ,CASE WHEN S.ZTXJJ IS NOT NULL THEN S.ZYXXXCYMC
           ELSE T11.INDUSTRY END             AS ZYXXXCYMC         --21 战略性新兴产业名称
          ,CASE WHEN S.ZTXJJ IS NOT NULL THEN S.SFTXWHCYDL
                WHEN T12.SFDX = 'Y'
                THEN ''
                WHEN T12.CODE IS NOT NULL
                THEN 'Y'
                ELSE 'N'
            END                              AS SFTXWHCYDL        --22 是否投向文化产业大类
          ,CASE WHEN S.ZTXJJ IS NOT NULL THEN S.WHCYMC
                WHEN T12.SFDX = 'Y'
                THEN T12.NAME||'*'
                WHEN T12.CODE IS NOT NULL
                THEN T12.NAME
                ELSE ''
            END                              AS WHCYMC            --23 文化产业名称
          ,CASE WHEN S.ZTXJJ IS NOT NULL THEN S.SFGYQYJSGZSJDK
           END                               AS SFGYQYJSGZSJDK    --24 是否工业企业技术改造升级贷款
          ,'N'                               AS SFYSHZ            --25 是否银税合作
          ,NULL                              AS SFNYCYHLTQY       --26 是否农业产业化龙头企业          补录字段，可置空，继承上一天数据
          ,'N'                               AS SFYQ              --27 是否延期
          ,'买断式转贴现'                    AS SYS_SOURCE        --28 来源系统
          ,CASE WHEN S.ZTXJJ IS NOT NULL THEN S.SFGXRBZ
           END                                      AS SFGXRBZ           --29 是否关系人保证
          ,T4.CUST_MGR_ID                           AS KHZBKHJLKHH       --30 客户主办客户经理客户号
          ,T16.TELLER_ID                            AS KHZBGYH           --31 客户主办柜员号
          ,NVL(T17.TELLER_NAME,T16.CLERK_NAME)      AS KHZBKHJLMC        --32 客户主办客户经理名称
          ,NVL(T17.BELONG_ORG_ID,T16.BELONG_ORG_ID) AS KHZBKHJLSSJG      --33 客户主办客户经理所属机构
          ,T18.CLERK_ID                             AS JJZBKHJLH         --34 借据主办客户经理号
          ,T2.RGST_TELLER_ID                        AS JJZBGYH           --35 借据主办柜员号
          ,NVL(T19.TELLER_NAME, T18.CLERK_NAME)     AS JJZBKHJLMC        --36 借据主办客户经理名称
          ,NVL(T19.BELONG_ORG_ID,T18.BELONG_ORG_ID) AS JJZBKHJLSSJG      --37 借据主办客户经理所属机构
          ,CASE WHEN T2.DISTR_DT < TO_DATE(V_P_DATE, 'YYYYMMDD') AND T2.PAYOFF_DT = TO_DATE(V_P_DATE, 'YYYYMMDD') AND T14.PAYOFF_FLG = '0'
                THEN ROUND((NVL(T1.CURRT_BAL, 0) - NVL(T1.INT_ADJ_BAL, 0) + NVL(T13.N_PV_VARIATION, 0)),2)  -- 根据行里报送，需加上发放日小于月末且结清日期为月末当天的数据
                WHEN NVL(T1.CURRT_BAL, 0) > 0 AND T2.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                THEN ROUND((NVL(T1.CURRT_BAL, 0) - NVL(T1.INT_ADJ_BAL, 0) + NVL(T13.N_PV_VARIATION, 0)),2)  -- 剔除公允价值变动
           ELSE 0 END                               AS LOAN_ACCT_BAL     --38 贷款余额  -- 公允价值变动四舍五入取小数点后二位
          ,T2.DISTR_DT                              AS DRAWDOWN_DT       --39 放款日期
          ,CASE WHEN SUBSTR(T2.DIR_INDUS_CD,0,4) = 'C245' THEN 'Y'
                WHEN T2.DIR_INDUS_CD IN ('F5149','F5249') THEN 'Y'
           ELSE '' END                               AS SFWJY             --40 是否玩具业
          ,CASE WHEN SUBSTR(T2.DIR_INDUS_CD,0,4) = 'C245' THEN P.SRC_VALUE_NAME
                WHEN T2.DIR_INDUS_CD IN ('F5149','F5249') THEN P.SRC_VALUE_NAME||'*'
           ELSE '' END                               AS WJHYMC            --41 玩具业行业名称
          ,''                                        AS SFZFZDXM          --42 是否政府重点项目
          ,''                                        AS SFSQQY            --43 是否涉侨企业
          ,''                                        AS GYLRZQY           --44 供应链融资企业
          ,CASE WHEN T2.DIR_INDUS_CD = 'C3462' THEN 'Y'
           END                                       AS SFTXHSFDCY        --45 是否投向海上风电产业
          ,''                                        AS SFTXHSFDCY        --46 是否投向海上风电产业
          ,''                                        AS SFZJTXZXQY        --47 是否专精特新中小企业
          ,''                                        AS SFJGMDZDZJTXZXQY  --48 是否监管名单中的专精特新中小企业
          ,CASE WHEN S.ZTXJJ IS NOT NULL THEN S.SFYLCY
           END                                       AS SFYLCY           --49 是否养老产业
          ,''                                        AS SFTXZFHSHZBHZ_PPP_XM --50 是否投向政府和社会资本合作（PPP）项目
          ,''                                        AS SFXJZFFDK         --51 是否新机制发放贷款
      FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO T1  -- 票据转贴现信息表
     INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T2 --对公贷款借据信息表
        ON T1.BILL_ID = T2.BILL_ID
       AND T2.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T3  --对公贷款合同信息表
        ON T2.CONT_ID = T3.CONT_ID
       AND T3.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T4  --对公客户基本信息表
        ON T2.CUST_ID = T4.CUST_ID
       AND T4.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T5 --内部机构信息表
        ON T1.ACCT_INSTIT_ID = T5.ORG_ID --
       AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN (SELECT DISTINCT CODE,NAME,SFDX,CYML,L_NAME FROM M_DICT_G0107_REMAPPING_BL WHERE TYPE_CODE = 'G010701') T8 --高技术产业
        ON T2.DIR_INDUS_CD = T8.CODE
      LEFT JOIN (SELECT DISTINCT CODE,NAME,SFDX FROM M_DICT_G0107_REMAPPING_BL WHERE TYPE_CODE = 'G010703') T9--知识产权密集型产业
        ON T2.DIR_INDUS_CD = T9.CODE
      LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.CODE ORDER BY T.S_CORE) RN FROM M_DICT_G0107_REMAPPING_BL T WHERE TYPE_CODE = 'G010702') T10--数字经济核心产业
        ON T2.DIR_INDUS_CD = T10.CODE
       AND T10.RN = 1
      LEFT JOIN  M_INDUSTRY_CLASSIFY T11
        ON T2.DIR_INDUS_CD = T11.INDUS_CATE_CD
       AND T11.CLASSIFY = '战略新兴'
      LEFT JOIN  (SELECT DISTINCT CYML,CODE,NAME,SFDX,SFDZBSY FROM M_DICT_G19_REMAPPING_BL WHERE TYPE_CODE = 'G1902' AND SFDZBSY = 'N') T11_1
        ON T2.DIR_INDUS_CD = T11_1.CODE
      LEFT JOIN  (SELECT DISTINCT CODE,NAME,SFDX,SFDZBSY FROM M_DICT_G19_REMAPPING_BL WHERE TYPE_CODE = 'G1902' AND SFDZBSY = 'Y') T11_2
        ON T2.DIR_INDUS_CD = T11_2.CODE
      LEFT JOIN (SELECT DISTINCT CODE,NAME,S_CORE,S_NAME,SFDX FROM M_DICT_G19_REMAPPING_BL WHERE TYPE_CODE = 'G1901') T12 --文化及相关产业
        ON T2.DIR_INDUS_CD = T12.CODE
     LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE T13 --估值报告表  关联估值表取 转贴现 公允价值变动
       --ON T13.V_TRADE_NO = T2.BILL_NUM
       ON T13.V_TRADE_NO = T2.BILL_ID --新票据关联字段变更
      AND T13.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO T14 --票据中心信息
       ON T14.BILL_ID = T1.BILL_ID
      AND T14.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO T15
        ON T2.STD_PROD_ID = T15.PROD_ID
       AND T15.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_GUAR_CONT T31 --担保合同表
        ON T3.CONT_ID = T31.GUAR_CONT_ID
       AND T31.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_CLERK_INFO T16
        ON T4.CUST_MGR_ID = T16.CLERK_ID
       AND T16.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_TELLER_INFO T17
        ON T16.TELLER_ID = T17.TELLER_ID
       AND T17.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.TELLER_ID ORDER BY T.DIMISSION_DT DESC) RN
                  FROM RRP_MDL.O_ICL_CMM_CLERK_INFO T
                 WHERE T.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
                   AND T.TELLER_ID IS NOT NULL
                ) T18
        ON T2.RGST_TELLER_ID = T18.TELLER_ID
       AND T18.RN = 1
      LEFT JOIN RRP_MDL.O_ICL_CMM_TELLER_INFO T19
        ON T2.RGST_TELLER_ID = T19.TELLER_ID
       AND T19.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN RRP_MDL.CODE_MAP P
             ON T2.DIR_INDUS_CD = P.SRC_VALUE_CODE
            AND P.SRC_CLASS_CODE = 'P0003'
            AND P.TAR_CLASS_CODE = 'P0003'
            AND P.MOD_FLG = 'MDM'
      LEFT JOIN TMP_XTNZTX S
             ON T2.DUBIL_ID = S.ZTXJJ
     WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND T1.TRAN_DIR_CD = '01'  --买入
      AND T1.BUS_TYPE_CD = 'BT01'  -- BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
      AND T1.ENTRY_STATUS_CD = '03'  -- 筛选记账成功的票据
      AND T2.STD_PROD_ID IN  ('204010100001','204010100002') --银行承兑汇票转贴现 ‘204010100002’ 商业承兑汇票转贴现
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

     /**************处理数据-插入目标表1****************/
  V_STEP      := 7;
  V_STEP_DESC := '处理数据-插入目标表1';
  V_STARTTIME := SYSDATE;

    INSERT INTO ADD_DG_003_MONEY NOLOGGING
    (
       DATA_DATE,       --01 数据日期,
       ACCT_ORG_NUM,    --02 账务机构编号,
       JYWYM,           --03 交易唯一码,
       ZHWYM,           --04 账户唯一码,
       KHWYM,           --05 客户唯一码,
       KHMC,            --06 客户名称,
       PJBH,            --07 票据编号,
       JBJGMC,          --08 经办机构名称,
       JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
       ZWJGMC,          --10 账务机构名称,
       ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
       TXGTJCYML,       --12 投向高技术产业门类,
       SFTXGJSCY,       --13 是否投向高技术产业,
       TXGJSZZYDLMC,    --14 投向高技术制造业大类,
       GJSCYMC,         --15 高技术产业名称,
       SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
       ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
       TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
       SZJJHXCYMC,      --19 数字经济核心产业名称,
       TXZLXXXCYML,     --20 投向战略性新兴产业门类,
       ZYXXXCYMC,       --21 战略性新兴产业名称,
       SFTXWHCYDL,      --22 是否投向文化产业大类,
       WHCYMC,          --23 文化产业名称,
       SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
       SFYSHZ,          --25 是否银税合作,
       SFNYCYHLTQY,     --26 是否农业产业化龙头企业
       SFYQ,            --27 是否延期,
       SYS_SOURCE,      --28 来源系统,
       SFGXRBZ,         --29 是否关系人保证,
       KHZBKHJLKHH,     --30 客户主办客户经理客户号,
       KHZBGYH,         --31 客户主办柜员号,
       KHZBKHJLMC,      --32 客户主办客户经理名称,
       KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
       JJZBKHJLH,       --34 借据主办客户经理号,
       JJZBGYH,         --35 借据主办柜员号,
       JJZBKHJLMC,      --36 借据主办客户经理名称,
       JJZBKHJLSSJG,    --37 借据主办客户经理所属机构
       SFWJY,           --38 是否玩具业
       WJHYMC,          --39 玩具业行业名称
       SFZFZDXM,        --40 是否政府重点项目
       SFSQQY,          --41 是否涉侨企业
       GYLRZQY,         --42 供应链融资企业
       SFTXHSFDCY,      --43 是否投向海上风电产业
       SFTXXXCNCY,      --44 是否投向新型储能产业
       SFZJTXZXQY,      --45 是否专精特新中小企业
       SFJGMDZDZJTXZXQY, --46 是否监管名单中的专精特新中小企业
       SFYLCY,           --47 是否养老产业
       SFTXZFHSHZBHZ_PPP_XM, --48 是否投向政府和社会资本合作（PPP）项目
       SFXJZFFDK,         --49 是否新机制发放贷款
       SFYZLLDLYQWJFXM,    --是否因资金链断裂导致的逾期未交付项目
       SFYZLLDLYQWJFXMKFRZ,--51 是否因资金链断裂导致的逾期未交付项目_开发融资
       SFYZLLDLYQWJFXMKFRZDK--52 是否因资金链断裂导致的逾期未交付项目_开发融资_贷款
    )
     WITH TMP AS (SELECT /*+ PARALLEL*/
           V_P_DATE  AS DATA_DATE,        --01 数据日期,
           ACCT_ORG_NUM,    --02 账务机构编号,
           JYWYM,           --03 交易唯一码,
           ZHWYM,           --04 账户唯一码,
           KHWYM,           --05 客户唯一码,
           KHMC,            --06 客户名称,
           PJBH,            --07 票据编号,
           JBJGMC,          --08 经办机构名称,
           JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
           ZWJGMC,          --10 账务机构名称,
           ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
           TXGTJCYML,       --12 投向高技术产业门类,
           SFTXGJSCY,       --13 是否投向高技术产业,
           TXGJSZZYDLMC,    --14 投向高技术制造业大类,
           GJSCYMC,         --15 高技术产业名称,
           SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
           ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
           TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
           SZJJHXCYMC,      --19 数字经济核心产业名称,
           TXZLXXXCYML,     --20 投向战略性新兴产业门类,
           ZYXXXCYMC,       --21 战略性新兴产业名称,
           SFTXWHCYDL,      --22 是否投向文化产业大类,
           WHCYMC,          --23 文化产业名称,
           SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
           SFYSHZ,          --25 是否银税合作,
           SFNYCYHLTQY,     --26 是否农业产业化龙头企业
           SFYQ,            --27 是否延期,
           SYS_SOURCE,      --28 来源系统,
           SFGXRBZ,         --29 是否关系人保证,
           KHZBKHJLKHH,     --30 客户主办客户经理客户号,
           KHZBGYH,         --31 客户主办柜员号,
           KHZBKHJLMC,      --32 客户主办客户经理名称,
           KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
           JJZBKHJLH,       --34 借据主办客户经理号,
           JJZBGYH,         --35 借据主办柜员号,
           JJZBKHJLMC,      --36 借据主办客户经理名称,
           JJZBKHJLSSJG,    --37 借据主办客户经理所属机构
           SFWJY,           --38 是否玩具业
           WJHYMC,          --39 玩具业行业名称
           SFZFZDXM,        --40 是否政府重点项目
           SFSQQY,          --41 是否涉侨企业
           GYLRZQY,         --42 供应链融资企业
           SFTXHSFDCY,      --43 是否投向海上风电产业
           SFTXXXCNCY,      --44 是否投向新型储能产业
           SFZJTXZXQY,      --45 是否专精特新中小企业
           SFJGMDZDZJTXZXQY, --46 是否监管名单中的专精特新中小企业
           SFYLCY,           --47 是否养老产业
           SFTXZFHSHZBHZ_PPP_XM, --48 是否投向政府和社会资本合作（PPP）项目
           SFXJZFFDK         --49 是否新机制发放贷款
      FROM ( SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.JYWYM ORDER BY A.SYS_OPER_DATE DESC) RN
              FROM ADD_DG_003_MONEY_ETL A
             WHERE A.DATA_DATE = V_P_DATE
           ) T
     WHERE T.RN = 1)
    SELECT /*+ PARALLEL*/
           V_P_DATE                                                        AS DATA_DATE         --01 数据日期
          ,T1.ACCT_ORG_NUM                                                 AS ACCT_ORG_NUM      --02 账务机构编号
          ,T1.JYWYM                                                        AS JYWYM             --03 交易唯一码
          ,T1.ZHWYM                                                        AS ZHWYM             --04 账户唯一码
          ,T1.KHWYM                                                        AS KHWYM             --05 客户唯一码
          ,T1.KHMC                                                         AS KHMC              --06 客户名称
          ,T1.PJBH                                                         AS PJBH              --07 票据编号
          ,T1.JBJGMC                                                       AS JBJGMC            --08 经办机构名称
          ,T1.JBJGJGSZXZQHDM                                               AS JBJGJGSZXZQHDM    --09 经办机构机构所在行政区划代码
          ,T1.ZWJGMC                                                       AS ZWJGMC            --10 账务机构名称
          ,T1.ZWJGJGSZXZQHDM                                               AS ZWJGJGSZXZQHDM    --11 账务机构机构所在行政区划代码
          ,COALESCE(TRIM(T2.TXGTJCYML),T3.TXGTJCYML,T1.TXGTJCYML)                AS TXGTJCYML         --12 投向高技术产业门类
          ,T1.SFTXGJSCY                                                          AS SFTXGJSCY         --13 是否投向高技术产业
          ,COALESCE(TRIM(T2.TXGJSZZYDLMC),T3.TXGJSZZYDLMC,T1.TXGJSZZYDLMC)       AS TXGJSZZYDLMC      --14 投向高技术制造业大类
          ,COALESCE(TRIM(T2.GJSCYMC),T3.GJSCYMC,T1.GJSCYMC)                      AS GJSCYMC           --15 高技术产业名称
          ,T1.SFTXZSCQMJXCY                                                      AS SFTXZSCQMJXCY     --16 是否投向知识产权密集型产业
          ,T1.ZSCQMJXCYMC                                                        AS ZSCQMJXCYMC       --17 知识产权密集型产业名称
          ,T1.TXSZJJHXCYDL                                                       AS TXSZJJHXCYDL      --18 投向数字经济核心产业大类 --直取信贷不需补录 20240619
          ,T1.SZJJHXCYMC                                                         AS SZJJHXCYMC        --19 数字经济核心产业名称 --直取信贷不需补录 20240619
          ,T1.TXZLXXXCYML                                                        AS TXZLXXXCYML       --20 投向战略性新兴产业门类 --直取信贷不需补录 20240619
          ,T1.ZYXXXCYMC                                                          AS ZYXXXCYMC         --21 战略性新兴产业名称 --直取信贷不需补录 20240619
          ,T1.SFTXWHCYDL                                                         AS SFTXWHCYDL        --22 是否投向文化产业大类 --直取信贷不需补录 20240619
          ,T1.WHCYMC                                                             AS WHCYMC            --23 文化产业名称
          ,T1.SFGYQYJSGZSJDK                                                     AS SFGYQYJSGZSJDK    --24 是否工业企业技术改造升级贷款 --直取信贷不需补录 20240619
          ,COALESCE(TRIM(T2.SFYSHZ),T3.SFYSHZ,T1.SFYSHZ)                         AS SFYSHZ            --25 是否银税合作
          ,COALESCE(TRIM(T2.SFNYCYHLTQY),T3.SFNYCYHLTQY,T1.SFNYCYHLTQY)          AS SFNYCYHLTQY       --26 是否农业产业化龙头企业
          ,COALESCE(TRIM(T2.SFYQ),T3.SFYQ,T1.SFYQ)                               AS SFYQ              --27 是否延期
          ,COALESCE(TRIM(T2.SYS_SOURCE),T3.SYS_SOURCE,T1.SYS_SOURCE)             AS SYS_SOURCE        --28 来源系统
          ,T1.SFGXRBZ                                                            AS SFGXRBZ           --29 是否关系人保证 直取信贷不需补录 20241022
          ,COALESCE(TRIM(T2.KHZBKHJLKHH),T3.KHZBKHJLKHH,T1.KHZBKHJLKHH)          AS KHZBKHJLKHH       --30 客户主办客户经理客户号
          ,COALESCE(TRIM(T2.KHZBGYH),T3.KHZBGYH,T1.KHZBGYH)                      AS KHZBGYH           --31 客户主办柜员号
          ,COALESCE(TRIM(T2.KHZBKHJLMC),T3.KHZBKHJLMC,T1.KHZBKHJLMC)             AS KHZBKHJLMC        --32 客户主办客户经理名称
          ,COALESCE(TRIM(T2.KHZBKHJLSSJG),T3.KHZBKHJLSSJG,T1.KHZBKHJLSSJG)       AS KHZBKHJLSSJG      --33 客户主办客户经理所属机构
          ,COALESCE(TRIM(T2.JJZBKHJLH),T3.JJZBKHJLH,T1.JJZBKHJLH)                AS JJZBKHJLH         --34 借据主办客户经理号
          ,COALESCE(TRIM(T2.JJZBGYH),T3.JJZBGYH,T1.JJZBGYH)                      AS JJZBGYH           --35 借据主办柜员号
          ,COALESCE(TRIM(T2.JJZBKHJLMC),T3.JJZBKHJLMC,T1.JJZBKHJLMC)             AS JJZBKHJLMC        --36 借据主办客户经理名称
          ,COALESCE(TRIM(T2.JJZBKHJLSSJG),T3.JJZBKHJLSSJG,T1.JJZBKHJLSSJG)       AS JJZBKHJLSSJG      --37 借据主办客户经理所属机构
          ,COALESCE(TRIM(T2.SFWJY),T3.SFWJY,T1.SFWJY)                            AS SFWJY             --38 是否玩具业
          ,COALESCE(TRIM(T2.WJHYMC),T3.WJHYMC,T1.WJHYMC)                         AS WJHYMC            --39 玩具业行业名称
          ,COALESCE(TRIM(T2.SFZFZDXM),T3.SFZFZDXM,T1.SFZFZDXM)                   AS SFZFZDXM          --40 是否政府重点项目
          ,COALESCE(TRIM(T2.SFSQQY),T3.SFSQQY,T1.SFSQQY)                         AS SFSQQY            --41 是否涉侨企业
          ,COALESCE(TRIM(T2.GYLRZQY),T3.GYLRZQY,T1.GYLRZQY)                      AS GYLRZQY           --42 供应链融资企业
          ,COALESCE(TRIM(T2.SFTXHSFDCY),T3.SFTXHSFDCY,T1.SFTXHSFDCY)             AS SFTXHSFDCY        --43 是否投向海上风电产业
          ,COALESCE(TRIM(T2.SFTXXXCNCY),T3.SFTXXXCNCY,T1.SFTXXXCNCY)             AS SFTXXXCNCY        --44 是否投向新型储能产业
          ,COALESCE(TRIM(T4.SFZJTXZXQY),T1.SFZJTXZXQY)                           AS SFZJTXZXQY        --45 是否专精特新中小企业    MODIFY BY YJY IN 20240228
          ,COALESCE(TRIM(T2.SFJGMDZDZJTXZXQY),T3.SFJGMDZDZJTXZXQY,T1.SFJGMDZDZJTXZXQY) AS SFJGMDZDZJTXZXQY --46 是否监管名单中的专精特新中小企业
          ,T1.SFYLCY                                                             AS SFYLCY            --47 是否养老产业 --直取信贷不需补录 20240619
          ,T1.SFTXZFHSHZBHZ_PPP_XM                                               AS SFTXZFHSHZBHZ_PPP_XM --48 是否投向政府和社会资本合作（PPP）项目 --直取信贷不需补录 20240619
          ,T1.SFXJZFFDK                                                          AS SFXJZFFDK           --49 是否新机制发放贷款 --直取信贷不需补录 20240619
          ,COALESCE(TRIM(T2.SFYZLLDLYQWJFXM),T3.SFYZLLDLYQWJFXM) --该字段无系统出数
          ,COALESCE(TRIM(T2.SFYZLLDLYQWJFXMKFRZ),T3.SFYZLLDLYQWJFXMKFRZ)--51 是否因资金链断裂导致的逾期未交付项目_开发融资
          ,COALESCE(TRIM(T2.SFYZLLDLYQWJFXMKFRZDK),T3.SFYZLLDLYQWJFXMKFRZDK)--52 是否因资金链断裂导致的逾期未交付项目_开发融资_贷款
      FROM TMP_ADD_DG_003_MONEY T1   --当天跑批数据
      LEFT JOIN ADD_DG_003_MONEY_L T2  --当天跑批后补录数据
        ON T1.JYWYM = T2.JYWYM
      LEFT JOIN (
      SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.JYWYM ORDER BY A.SYS_OPER_DATE DESC) RN
      FROM ADD_DG_003_MONEY_ETL A
      WHERE A.DATA_DATE = M_DATA_DATE
       ) T3  --上一天数据
        ON T1.JYWYM = T3.JYWYM
        AND T3.RN = 1
      LEFT JOIN TMP        T4 --当天跑批后补录数据    MODIFY BY YJY IN 20240228
             ON T1.JYWYM = T4.JYWYM
     WHERE T1.LOAN_ACCT_BAL <> 0 OR TO_CHAR(T1.DRAWDOWN_DT,'YYYY') = SUBSTR(V_P_DATE,1,4)
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    /**************处理数据-插入目标表2****************/
  V_STEP      := 8;
  V_STEP_DESC := '处理数据-插入目标表2';
  V_STARTTIME := SYSDATE;

   INSERT INTO ADD_DG_003_MONEY NOLOGGING
    (
       DATA_DATE,       --01 数据日期,
       ACCT_ORG_NUM,    --02 账务机构编号,
       JYWYM,           --03 交易唯一码,
       ZHWYM,           --04 账户唯一码,
       KHWYM,           --05 客户唯一码,
       KHMC,            --06 客户名称,
       PJBH,            --07 票据编号,
       JBJGMC,          --08 经办机构名称,
       JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
       ZWJGMC,          --10 账务机构名称,
       ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
       TXGTJCYML,       --12 投向高技术产业门类,
       SFTXGJSCY,       --13 是否投向高技术产业,
       TXGJSZZYDLMC,    --14 投向高技术制造业大类,
       GJSCYMC,         --15 高技术产业名称,
       SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
       ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
       TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
       SZJJHXCYMC,      --19 数字经济核心产业名称,
       TXZLXXXCYML,     --20 投向战略性新兴产业门类,
       ZYXXXCYMC,       --21 战略性新兴产业名称,
       SFTXWHCYDL,      --22 是否投向文化产业大类,
       WHCYMC,          --23 文化产业名称,
       SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
       SFYSHZ,          --25 是否银税合作,
       SFNYCYHLTQY,     --26 是否农业产业化龙头企业
       SFYQ,            --27 是否延期,
       SYS_SOURCE,      --28 来源系统,
       SFGXRBZ,         --29 是否关系人保证,
       KHZBKHJLKHH,     --30 客户主办客户经理客户号,
       KHZBGYH,         --31 客户主办柜员号,
       KHZBKHJLMC,      --32 客户主办客户经理名称,
       KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
       JJZBKHJLH,       --34 借据主办客户经理号,
       JJZBGYH,         --35 借据主办柜员号,
       JJZBKHJLMC,      --36 借据主办客户经理名称,
       JJZBKHJLSSJG,    --37 借据主办客户经理所属机构
       SFWJY,           --38 是否玩具业
       WJHYMC,          --39 玩具业行业名称
       SFZFZDXM,        --40 是否政府重点项目
       SFSQQY,          --41 是否涉侨企业
       GYLRZQY,         --42 供应链融资企业
       SFTXHSFDCY,      --43 是否投向海上风电产业
       SFTXXXCNCY,      --44 是否投向新型储能产业
       SFZJTXZXQY,      --45 是否专精特新中小企业
       SFJGMDZDZJTXZXQY, --46 是否监管名单中的专精特新中小企业
       SFYLCY,            --47 是否养老产业
       SFTXZFHSHZBHZ_PPP_XM, --48 是否投向政府和社会资本合作（PPP）项目
       SFXJZFFDK,           --49 是否新机制发放贷款
       SFYZLLDLYQWJFXM,    --50 是否因资金链断裂导致的逾期未交付项目
       SFYZLLDLYQWJFXMKFRZ,--51 是否因资金链断裂导致的逾期未交付项目_开发融资
       SFYZLLDLYQWJFXMKFRZDK--52 是否因资金链断裂导致的逾期未交付项目_开发融资_贷款
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE                                                        AS DATA_DATE         --01 数据日期
          ,T1.ACCT_ORG_NUM                                                 AS ACCT_ORG_NUM      --02 账务机构编号
          ,T1.JYWYM                                                        AS JYWYM             --03 交易唯一码
          ,T1.ZHWYM                                                        AS ZHWYM             --04 账户唯一码
          ,T1.KHWYM                                                        AS KHWYM             --05 客户唯一码
          ,T1.KHMC                                                         AS KHMC              --06 客户名称
          ,T1.PJBH                                                         AS PJBH              --07 票据编号
          ,T1.JBJGMC                                                       AS JBJGMC            --08 经办机构名称
          ,T1.JBJGJGSZXZQHDM                                               AS JBJGJGSZXZQHDM    --09 经办机构机构所在行政区划代码
          ,T1.ZWJGMC                                                       AS ZWJGMC            --10 账务机构名称
          ,T1.ZWJGJGSZXZQHDM                                               AS ZWJGJGSZXZQHDM    --11 账务机构机构所在行政区划代码
          ,COALESCE(TRIM(T2.TXGTJCYML),T3.TXGTJCYML,T1.TXGTJCYML)                AS TXGTJCYML         --12 投向高技术产业门类
          ,T1.SFTXGJSCY                                                          AS SFTXGJSCY         --13 是否投向高技术产业 --直取信贷不需补录 20240619
          ,COALESCE(TRIM(T2.TXGJSZZYDLMC),T3.TXGJSZZYDLMC,T1.TXGJSZZYDLMC)       AS TXGJSZZYDLMC      --14 投向高技术制造业大类
          ,COALESCE(TRIM(T2.GJSCYMC),T3.GJSCYMC,T1.GJSCYMC)                      AS GJSCYMC           --15 高技术产业名称
          ,T1.SFTXZSCQMJXCY                                                      AS SFTXZSCQMJXCY     --16 是否投向知识产权密集型产业
          ,T1.ZSCQMJXCYMC                                                        AS ZSCQMJXCYMC       --17 知识产权密集型产业名称
          ,T1.TXSZJJHXCYDL                                                       AS TXSZJJHXCYDL      --18 投向数字经济核心产业大类 --直取信贷不需补录 20240619
          ,T1.SZJJHXCYMC                                                         AS SZJJHXCYMC        --19 数字经济核心产业名称 --直取信贷不需补录 20240619
          ,T1.TXZLXXXCYML                                                        AS TXZLXXXCYML       --20 投向战略性新兴产业门类 --直取信贷不需补录 20240619
          ,T1.ZYXXXCYMC                                                          AS ZYXXXCYMC         --21 战略性新兴产业名称 --直取信贷不需补录 20240619
          ,T1.SFTXWHCYDL                                                         AS SFTXWHCYDL        --22 是否投向文化产业大类 --直取信贷不需补录 20240619
          ,T1.WHCYMC                                                             AS WHCYMC            --23 文化产业名称
          ,T1.SFGYQYJSGZSJDK                                                     AS SFGYQYJSGZSJDK    --24 是否工业企业技术改造升级贷款 --直取信贷不需补录 20240619
          ,COALESCE(TRIM(T2.SFYSHZ),T3.SFYSHZ,T1.SFYSHZ)                         AS SFYSHZ            --25 是否银税合作
          ,COALESCE(TRIM(T2.SFNYCYHLTQY),T3.SFNYCYHLTQY,T1.SFNYCYHLTQY)          AS SFNYCYHLTQY       --26 是否农业产业化龙头企业
          ,COALESCE(TRIM(T2.SFYQ),T3.SFYQ,T1.SFYQ)                               AS SFYQ              --27 是否延期
          ,COALESCE(TRIM(T2.SYS_SOURCE),T3.SYS_SOURCE,T1.SYS_SOURCE)             AS SYS_SOURCE        --28 来源系统
          ,T1.SFGXRBZ                                                            AS SFGXRBZ           --29 是否关系人保证 --直取信贷不需补录 20241022
          ,COALESCE(TRIM(T2.KHZBKHJLKHH),T3.KHZBKHJLKHH,T1.KHZBKHJLKHH)          AS KHZBKHJLKHH       --30 客户主办客户经理客户号
          ,COALESCE(TRIM(T2.KHZBGYH),T3.KHZBGYH,T1.KHZBGYH)                      AS KHZBGYH           --31 客户主办柜员号
          ,COALESCE(TRIM(T2.KHZBKHJLMC),T3.KHZBKHJLMC,T1.KHZBKHJLMC)             AS KHZBKHJLMC        --32 客户主办客户经理名称
          ,COALESCE(TRIM(T2.KHZBKHJLSSJG),T3.KHZBKHJLSSJG,T1.KHZBKHJLSSJG)       AS KHZBKHJLSSJG      --33 客户主办客户经理所属机构
          ,COALESCE(TRIM(T2.JJZBKHJLH),T3.JJZBKHJLH,T1.JJZBKHJLH)                AS JJZBKHJLH         --34 借据主办客户经理号
          ,COALESCE(TRIM(T2.JJZBGYH),T3.JJZBGYH,T1.JJZBGYH)                      AS JJZBGYH           --35 借据主办柜员号
          ,COALESCE(TRIM(T2.JJZBKHJLMC),T3.JJZBKHJLMC,T1.JJZBKHJLMC)             AS JJZBKHJLMC        --36 借据主办客户经理名称
          ,COALESCE(TRIM(T2.JJZBKHJLSSJG),T3.JJZBKHJLSSJG,T1.JJZBKHJLSSJG)       AS JJZBKHJLSSJG      --37 借据主办客户经理所属机构
          ,COALESCE(TRIM(T2.SFWJY),T3.SFWJY,T1.SFWJY)                            AS SFWJY             --38 是否玩具业
          ,COALESCE(TRIM(T2.WJHYMC),T3.WJHYMC,T1.WJHYMC)                         AS WJHYMC            --39 玩具业行业名称
          ,COALESCE(TRIM(T2.SFZFZDXM),T3.SFZFZDXM,T1.SFZFZDXM)                   AS SFZFZDXM          --40 是否政府重点项目
          ,COALESCE(TRIM(T2.SFSQQY),T3.SFSQQY,T1.SFSQQY)                         AS SFSQQY            --41 是否涉侨企业
          ,COALESCE(TRIM(T2.GYLRZQY),T3.GYLRZQY,T1.GYLRZQY)                      AS GYLRZQY           --42 供应链融资企业
          ,COALESCE(TRIM(T2.SFTXHSFDCY),T3.SFTXHSFDCY,T1.SFTXHSFDCY)             AS SFTXHSFDCY        --43 是否投向海上风电产业
          ,COALESCE(TRIM(T2.SFTXXXCNCY),T3.SFTXXXCNCY,T1.SFTXXXCNCY)             AS SFTXXXCNCY        --44 是否投向新型储能产业
          ,COALESCE(TRIM(T2.SFZJTXZXQY),T3.SFZJTXZXQY,T1.SFZJTXZXQY)             AS SFZJTXZXQY        --45 是否专精特新中小企业
          ,COALESCE(TRIM(T2.SFJGMDZDZJTXZXQY),T3.SFJGMDZDZJTXZXQY,T1.SFJGMDZDZJTXZXQY) AS SFJGMDZDZJTXZXQY --46 是否监管名单中的专精特新中小企业
          ,T1.SFYLCY                                                             AS SFYLCY            --47 是否养老产业 --直取信贷不需补录 20240619
          ,T1.SFTXZFHSHZBHZ_PPP_XM                                               AS SFTXZFHSHZBHZ_PPP_XM    --48 是否投向政府和社会资本合作（PPP）项目 --直取信贷不需补录 20240619
          ,T1.SFXJZFFDK                                                          AS SFXJZFFDK           --49 是否新机制发放贷款 --直取信贷不需补录 20240619
          ,COALESCE(TRIM(T2.SFYZLLDLYQWJFXM),T3.SFYZLLDLYQWJFXM)                 AS SFYZLLDLYQWJFXM     --50 是否因资金链断裂导致的逾期未交付项目
          ,COALESCE(TRIM(T2.SFYZLLDLYQWJFXMKFRZ),T3.SFYZLLDLYQWJFXMKFRZ)--51 是否因资金链断裂导致的逾期未交付项目_开发融资
          ,COALESCE(TRIM(T2.SFYZLLDLYQWJFXMKFRZDK),T3.SFYZLLDLYQWJFXMKFRZDK)--52 是否因资金链断裂导致的逾期未交付项目_开发融资_贷款
      FROM TMP_ADD_DG_003_MONEY T1    --当天跑批数据
      LEFT JOIN ADD_DG_003_MONEY_L T2  --当天跑批后补录数据
        ON T1.JYWYM = T2.JYWYM
      LEFT JOIN (
      SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.JYWYM ORDER BY A.SYS_OPER_DATE DESC) RN
      FROM ADD_DG_003_MONEY_ETL A
      WHERE A.DATA_DATE = M_DATA_DATE
       ) T3   --上一天数据
        ON T1.JYWYM = T3.JYWYM
        AND T3.RN = 1
     WHERE EXISTS(SELECT 1
                    FROM O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息
                   WHERE A.DUBIL_ID = T1.JYWYM
                     AND A.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')-1
                     AND A.DUBIL_BAL <> 0
                 )
       AND NOT EXISTS(SELECT 1 FROM ADD_DG_003_MONEY T WHERE T.DATA_DATE = V_P_DATE AND T1.JYWYM = T.JYWYM)
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
/*
   V_STEP      := 9;
   V_STEP_DESC := '处理数据-上一期数据插入目标表';
   V_STARTTIME := SYSDATE;

    INSERT INTO ADD_DG_003_MONEY
   (
       DATA_DATE,       --01 数据日期,
       ACCT_ORG_NUM,    --02 账务机构编号,
       JYWYM,           --03 交易唯一码,
       ZHWYM,           --04 账户唯一码,
       KHWYM,           --05 客户唯一码,
       KHMC,            --06 客户名称,
       PJBH,            --07 票据编号,
       JBJGMC,          --08 经办机构名称,
       JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
       ZWJGMC,          --10 账务机构名称,
       ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
       TXGTJCYML,       --12 投向高技术产业门类,
       SFTXGJSCY,       --13 是否投向高技术产业,
       TXGJSZZYDLMC,    --14 投向高技术制造业大类,
       GJSCYMC,         --15 高技术产业名称,
       SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
       ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
       TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
       SZJJHXCYMC,      --19 数字经济核心产业名称,
       TXZLXXXCYML,     --20 投向战略性新兴产业门类,
       ZYXXXCYMC,       --21 战略性新兴产业名称,
       SFTXWHCYDL,      --22 是否投向文化产业大类,
       WHCYMC,          --23 文化产业名称,
       SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
       SFYSHZ,          --25 是否银税合作,
       SFNYCYHLTQY,     --26 是否农业产业化龙头企业
       SFYQ,            --27 是否延期,
       SYS_SOURCE,      --28 来源系统,
       SFGXRBZ,         --29 是否关系人保证,
       KHZBKHJLKHH,     --30 客户主办客户经理客户号,
       KHZBGYH,         --31 客户主办柜员号,
       KHZBKHJLMC,      --32 客户主办客户经理名称,
       KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
       JJZBKHJLH,       --34 借据主办客户经理号,
       JJZBGYH,         --35 借据主办柜员号,
       JJZBKHJLMC,      --36 借据主办客户经理名称,
       JJZBKHJLSSJG     --37 借据主办客户经理所属机构
   )
   SELECT
       V_P_DATE,        --01 数据日期,
       ACCT_ORG_NUM,    --02 账务机构编号,
       JYWYM,           --03 交易唯一码,
       ZHWYM,           --04 账户唯一码,
       KHWYM,           --05 客户唯一码,
       KHMC,            --06 客户名称,
       PJBH,            --07 票据编号,
       JBJGMC,          --08 经办机构名称,
       JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
       ZWJGMC,          --10 账务机构名称,
       ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
       TXGTJCYML,       --12 投向高技术产业门类,
       SFTXGJSCY,       --13 是否投向高技术产业,
       TXGJSZZYDLMC,    --14 投向高技术制造业大类,
       GJSCYMC,         --15 高技术产业名称,
       SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
       ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
       TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
       SZJJHXCYMC,      --19 数字经济核心产业名称,
       TXZLXXXCYML,     --20 投向战略性新兴产业门类,
       ZYXXXCYMC,       --21 战略性新兴产业名称,
       SFTXWHCYDL,      --22 是否投向文化产业大类,
       WHCYMC,          --23 文化产业名称,
       SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
       SFYSHZ,          --25 是否银税合作,
       SFNYCYHLTQY,     --26 是否农业产业化龙头企业
       SFYQ,            --27 是否延期,
       SYS_SOURCE,      --28 来源系统,
       SFGXRBZ,         --29 是否关系人保证,
       KHZBKHJLKHH,     --30 客户主办客户经理客户号,
       KHZBGYH,         --31 客户主办柜员号,
       KHZBKHJLMC,      --32 客户主办客户经理名称,
       KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
       JJZBKHJLH,       --34 借据主办客户经理号,
       JJZBGYH,         --35 借据主办柜员号,
       JJZBKHJLMC,      --36 借据主办客户经理名称,
       JJZBKHJLSSJG     --37 借据主办客户经理所属机构
   FROM (
    SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.KHWYM ORDER BY A.SYS_OPER_DATE DESC) RN
    FROM ADD_DG_003_MONEY_ETL A
    WHERE A.DATA_DATE = (SELECT MAX(TT.DATA_DATE) FROM ADD_DG_003_MONEY_ETL TT WHERE TT.DATA_DATE < V_P_DATE)
         ) TA
   WHERE NOT EXISTS (SELECT 1 FROM ADD_DG_003_MONEY T WHERE T.DATA_DATE = V_P_DATE AND TA.JYWYM = T.JYWYM)
   AND TA.RN = 1
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP      := 10;
   V_STEP_DESC := '处理数据-当期增加的数据插入目标表';
   V_STARTTIME := SYSDATE;

    INSERT INTO ADD_DG_003_MONEY
   (
       DATA_DATE,       --01 数据日期,
       ACCT_ORG_NUM,    --02 账务机构编号,
       JYWYM,           --03 交易唯一码,
       ZHWYM,           --04 账户唯一码,
       KHWYM,           --05 客户唯一码,
       KHMC,            --06 客户名称,
       PJBH,            --07 票据编号,
       JBJGMC,          --08 经办机构名称,
       JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
       ZWJGMC,          --10 账务机构名称,
       ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
       TXGTJCYML,       --12 投向高技术产业门类,
       SFTXGJSCY,       --13 是否投向高技术产业,
       TXGJSZZYDLMC,    --14 投向高技术制造业大类,
       GJSCYMC,         --15 高技术产业名称,
       SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
       ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
       TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
       SZJJHXCYMC,      --19 数字经济核心产业名称,
       TXZLXXXCYML,     --20 投向战略性新兴产业门类,
       ZYXXXCYMC,       --21 战略性新兴产业名称,
       SFTXWHCYDL,      --22 是否投向文化产业大类,
       WHCYMC,          --23 文化产业名称,
       SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
       SFYSHZ,          --25 是否银税合作,
       SFNYCYHLTQY,     --26 是否农业产业化龙头企业
       SFYQ,            --27 是否延期,
       SYS_SOURCE,      --28 来源系统,
       SFGXRBZ,         --29 是否关系人保证,
       KHZBKHJLKHH,     --30 客户主办客户经理客户号,
       KHZBGYH,         --31 客户主办柜员号,
       KHZBKHJLMC,      --32 客户主办客户经理名称,
       KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
       JJZBKHJLH,       --34 借据主办客户经理号,
       JJZBGYH,         --35 借据主办柜员号,
       JJZBKHJLMC,      --36 借据主办客户经理名称,
       JJZBKHJLSSJG     --37 借据主办客户经理所属机构
   )
   SELECT
       V_P_DATE,        --01 数据日期,
       ACCT_ORG_NUM,    --02 账务机构编号,
       JYWYM,           --03 交易唯一码,
       ZHWYM,           --04 账户唯一码,
       KHWYM,           --05 客户唯一码,
       KHMC,            --06 客户名称,
       PJBH,            --07 票据编号,
       JBJGMC,          --08 经办机构名称,
       JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
       ZWJGMC,          --10 账务机构名称,
       ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
       TXGTJCYML,       --12 投向高技术产业门类,
       SFTXGJSCY,       --13 是否投向高技术产业,
       TXGJSZZYDLMC,    --14 投向高技术制造业大类,
       GJSCYMC,         --15 高技术产业名称,
       SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
       ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
       TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
       SZJJHXCYMC,      --19 数字经济核心产业名称,
       TXZLXXXCYML,     --20 投向战略性新兴产业门类,
       ZYXXXCYMC,       --21 战略性新兴产业名称,
       SFTXWHCYDL,      --22 是否投向文化产业大类,
       WHCYMC,          --23 文化产业名称,
       SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
       SFYSHZ,          --25 是否银税合作,
       SFNYCYHLTQY,     --26 是否农业产业化龙头企业
       SFYQ,            --27 是否延期,
       SYS_SOURCE,      --28 来源系统,
       SFGXRBZ,         --29 是否关系人保证,
       KHZBKHJLKHH,     --30 客户主办客户经理客户号,
       KHZBGYH,         --31 客户主办柜员号,
       KHZBKHJLMC,      --32 客户主办客户经理名称,
       KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
       JJZBKHJLH,       --34 借据主办客户经理号,
       JJZBGYH,         --35 借据主办柜员号,
       JJZBKHJLMC,      --36 借据主办客户经理名称,
       JJZBKHJLSSJG     --37 借据主办客户经理所属机构
   FROM ADD_DG_003_MONEY_L A
   WHERE NOT EXISTS (SELECT 1 FROM ADD_DG_003_MONEY T WHERE T.DATA_DATE = V_P_DATE AND A.JYWYM = T.JYWYM)
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
*/
   V_STEP      := 11;
   V_STEP_DESC := '增加表分析及跑批过程完成表';
   V_STARTTIME := SYSDATE;

     --表分析
     ETL_DBMS_STATS(V_P_DATE, V_TABLE_NAME, V_PART_NAME, O_ERRCODE);
     --插入过程跑批完成记录表
     INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
     VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 -- 数据重复校验 --
  WITH TMP1 AS (
    SELECT DATA_DATE,JYWYM,COUNT(1)
      FROM RRP_MDL.ADD_DG_003_MONEY T
     WHERE DATA_DATE = V_P_DATE
     GROUP BY DATA_DATE,JYWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

   -- 程序跑批结束记录 --
   V_STEP      := 12;
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序异常处理部分 --
EXCEPTION
   WHEN OTHERS THEN
     V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE   := '1';
     V_ENDTIME   := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_ADD_DG_003_MONEY;
/

