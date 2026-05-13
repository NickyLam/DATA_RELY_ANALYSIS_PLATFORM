CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_ADD_DG_003_MONEY(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_M_ADD_DG_003_MONEY
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
  *  目标表：  M_ADD_DG_003_MONEY  --账务基表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221115  hulj     首次创建。
  *             2    20230531  liuyu    新增重复值校验
  *             3    20230603  HYF      修改投向数字经济核心产业中类
                4    20230614  liuyu    调整重组标志判读，调整码值映射
                5    20230706  MW       调整投向数字核心产业大类逻辑，优先从补录表取数
                6    20230822  lwb      调整核心产业的技术逻辑，因etl表的原始码值与s_loan不一致，所以优先把码值转成中文，
                7    20231207  HYF      新增是否玩具业等6个字段
                8    20240124  hulj     新增字段是否专精特新中小企业、是否监管名单中的专精特新中小企业
                9    20240125  HYF      投向数字经济核心产业中类新增码值05 数字化效率提升业
                10   20240131  HYF      专精特新字段先屏蔽，2月再投
                11   20240219  YJY      加工专精特新字段
                12   20240220  YJY      新增”是否养老产业”
                13   20240226  YJY      新增"是否投向政府和社会资本合作（PPP）项目","是否新机制发放贷款"
  *             14   20240624  HYF      信贷标识字段优先取当天跑批数据再取继承表
                15   20240806  LWB      新增是否因资金链断裂导致的逾期未交付项目_开发融资，开发融资_贷款字段
  *             16   20241030  HYF      是否知识密集型产业取当天跑批数据不再补录             
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                              -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                                    -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30)   := 'ETL_M_ADD_DG_003_MONEY';       -- 程序名称
  V_TABLE_NAME  VARCHAR2(30)   := 'M_ADD_DG_003_MONEY';           -- 报表名称
  V_PART_NAME   VARCHAR2(100);                                    -- 分区名称
  V_P_DATE      VARCHAR2(8);                                      -- 跑批数据日期
  V_STARTTIME   DATE;                                             -- 处理开始时间
  V_ENDTIME     DATE;                                             -- 处理结束时间
  V_SQLCOUNT    INTEGER        := 0;                              -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                                    -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                                     -- 来源系统

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

   --DELETE FROM M_ADD_DG_003_MONEY T WHERE T.DATA_DATE = V_P_DATE;--普通表的重跑处理
   ETL_PARTITION_ADD(I_P_DATE,V_TABLE_NAME,1,O_ERRCODE);--增加当天跑批分区

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := 2;
  V_STEP_DESC := '继承ADD的数据插入到临时表';
  V_STARTTIME := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_M_ADD_DG_003_MONEY';

  INSERT INTO TMP_M_ADD_DG_003_MONEY
     (
      DATA_DATE,         --01 数据日期,
      ACCT_ORG_NUM,      --02 账务机构编号,
      JYWYM,             --03 交易唯一码,
      ZHWYM,             --04 账户唯一码,
      KHWYM,             --05 客户唯一码,
      KHMC,              --06 客户名称,
      PJBH,              --07 票据编号,
      JBJGMC,            --08 经办机构名称,
      JBJGJGSZXZQHDM,    --09 经办机构机构所在行政区划代码,
      ZWJGMC,            --10 账务机构名称,
      ZWJGJGSZXZQHDM,    --11 账务机构机构所在行政区划代码,
      TXGTJCYML,         --12 投向高技术产业门类,
      SFTXGJSCY,         --13 是否投向高技术产业,
      TXGJSZZYDLMC,      --14 投向高技术制造业大类,
      GJSCYMC,           --15 高技术产业名称,
      SFTXZSCQMJXCY,     --16 是否投向知识产权密集型产业,
      ZSCQMJXCYMC,       --17 知识产权密集型产业名称,
      TXSZJJHXCYDL,      --18 投向数字经济核心产业大类,
      SZJJHXCYMC,        --19 数字经济核心产业名称,
      TXZLXXXCYML,       --20 投向战略性新兴产业门类,
      ZYXXXCYMC,         --21 战略性新兴产业名称,
      SFTXWHCYDL,        --22 是否投向文化产业大类,
      WHCYMC,            --23 文化产业名称,
      SFGYQYJSGZSJDK,    --24 是否工业企业技术改造升级贷款,
      SFYSHZ,            --25 是否银税合作,
      SFNYCYHLTQY,       --26 是否农业产业化龙头企业
      SFYQ,              --27 是否延期,
      SYS_SOURCE,        --28 来源系统,
      SFGXRBZ,           --29 是否关系人保证,
      KHZBKHJLKHH,       --30 客户主办客户经理客户号,
      KHZBGYH,           --31 客户主办柜员号,
      KHZBKHJLMC,        --32 客户主办客户经理名称,
      KHZBKHJLSSJG,      --33 客户主办客户经理所属机构,
      JJZBKHJLH,         --34 借据主办客户经理号,
      JJZBGYH,           --35 借据主办柜员号,
      JJZBKHJLMC,        --36 借据主办客户经理名称,
      JJZBKHJLSSJG,      --37 借据主办客户经理所属机构
      SFWJY,             --38 是否玩具业
      WJHYMC,            --39 玩具业行业名称
      SFZFZDXM,          --40 是否政府重点项目
      SFSQQY,            --41 是否涉侨企业
      GYLRZQY,           --42 供应链融资企业
      SFTXHSFDCY,        --43 是否投向海上风电产业
      SFTXXXCNCY,        --44 是否投向新型储能产业
      SFZJTXZXQY,        --45 是否专精特新中小企业      --MODIFY BY YJY IN 20240219
      SFJGMDZDZJTXZXQY,   --46 是否监管名单中的专精特新中小企业          --MODIFY BY YJY IN 20240219
      SFYLCY,             --47 是否养老产业
      SFTXZFHSHZBHZ_PPP_XM, --48 是否投向政府和社会资本合作（PPP）项目
      SFXJZFFDK,         --49 是否新机制发放贷款
      SFYZLLDLYQWJFXM,    --50 是否因资金链断裂导致的逾期未交付项目
      SFYZLLDLYQWJFXMKFRZ,--51 是否因资金链断裂导致的逾期未交付项目_开发融资
      SFYZLLDLYQWJFXMKFRZDK--52 是否因资金链断裂导致的逾期未交付项目_开发融资_贷款
    )
    SELECT /*+ PARALLEL(A,4) */
      DATA_DATE,         --01 数据日期,
      ACCT_ORG_NUM,      --02 账务机构编号,
      JYWYM,             --03 交易唯一码,
      ZHWYM,             --04 账户唯一码,
      KHWYM,             --05 客户唯一码,
      KHMC,              --06 客户名称,
      PJBH,              --07 票据编号,
      JBJGMC,            --08 经办机构名称,
      JBJGJGSZXZQHDM,    --09 经办机构机构所在行政区划代码,
      ZWJGMC,            --10 账务机构名称,
      ZWJGJGSZXZQHDM,    --11 账务机构机构所在行政区划代码,
      TXGTJCYML,         --12 投向高技术产业门类,
      SFTXGJSCY,         --13 是否投向高技术产业,
      TXGJSZZYDLMC,      --14 投向高技术制造业大类,
      GJSCYMC,           --15 高技术产业名称,
      SFTXZSCQMJXCY,     --16 是否投向知识产权密集型产业,
      ZSCQMJXCYMC,       --17 知识产权密集型产业名称,
      TXSZJJHXCYDL,      --18 投向数字经济核心产业大类,
      SZJJHXCYMC,        --19 数字经济核心产业名称,
      TXZLXXXCYML,       --20 投向战略性新兴产业门类,
      ZYXXXCYMC,         --21 战略性新兴产业名称,
      SFTXWHCYDL,        --22 是否投向文化产业大类,
      WHCYMC,            --23 文化产业名称,
      SFGYQYJSGZSJDK,    --24 是否工业企业技术改造升级贷款,
      SFYSHZ,            --25 是否银税合作,
      SFNYCYHLTQY,       --26 是否农业产业化龙头企业
      SFYQ,              --27 是否延期,
      SYS_SOURCE,        --28 来源系统,
      SFGXRBZ,           --29 是否关系人保证,
      KHZBKHJLKHH,       --30 客户主办客户经理客户号,
      KHZBGYH,           --31 客户主办柜员号,
      KHZBKHJLMC,        --32 客户主办客户经理名称,
      KHZBKHJLSSJG,      --33 客户主办客户经理所属机构,
      JJZBKHJLH,         --34 借据主办客户经理号,
      JJZBGYH,           --35 借据主办柜员号,
      JJZBKHJLMC,        --36 借据主办客户经理名称,
      JJZBKHJLSSJG,      --37 借据主办客户经理所属机构
      SFWJY,             --38 是否玩具业
      WJHYMC,            --39 玩具业行业名称
      SFZFZDXM,          --40 是否政府重点项目
      SFSQQY,            --41 是否涉侨企业
      GYLRZQY,           --42 供应链融资企业
      SFTXHSFDCY,        --43 是否投向海上风电产业
      SFTXXXCNCY,        --44 是否投向新型储能产业
      SFZJTXZXQY,        --45 是否专精特新中小企业          --MODIFY BY YJY IN 20240219
      SFJGMDZDZJTXZXQY,   --46 是否监管名单中的专精特新中小企业           --MODIFY BY YJY IN 20240219
      SFYLCY,             --47 是否养老产业
      SFTXZFHSHZBHZ_PPP_XM, --48 是否投向政府和社会资本合作（PPP）项目
      SFXJZFFDK,         --49 是否新机制发放贷款
      SFYZLLDLYQWJFXM,    --50 是否因资金链断裂导致的逾期未交付项目
      SFYZLLDLYQWJFXMKFRZ,--51 是否因资金链断裂导致的逾期未交付项目_开发融资
      SFYZLLDLYQWJFXMKFRZDK--52 是否因资金链断裂导致的逾期未交付项目_开发融资_贷款
    FROM (
      SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.JYWYM ORDER BY A.SYS_OPER_DATE DESC) RN
      FROM ADD_DG_003_MONEY_ETL A
      WHERE A.DATA_DATE = V_P_DATE
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
   V_STEP_DESC := 'ADD数据与跑批数据插入到目标表';
   V_STARTTIME := SYSDATE;

   INSERT INTO M_ADD_DG_003_MONEY
    (
     DATA_DATE,         --01 数据日期
     ACCT_ORG_NUM,      --02 账务机构编号
     JYWYM,             --03 交易唯一码
     ZHWYM,             --04 账户唯一码
     KHWYM,             --05 客户唯一码
     KHMC,              --06 客户名称
     PJBH,              --07 票据编号
     JBJGMC,            --08 经办机构名称
     JBJGJGSZXZQHDM,    --09 经办机构机构所在行政区划代码
     ZWJGMC,            --10 账务机构名称
     ZWJGJGSZXZQHDM,    --11 账务机构机构所在行政区划代码
     DKPZMC,            --12 贷款品种名称
     TXGTJCYML,         --13 投向高技术产业门类
     SFTXGJSCY,         --14 是否投向高技术产业
     TXGJSZZYDLMC,      --15 投向高技术制造业大类
     GJSCYMC,           --16 高技术产业名称
     SFTXZSCQMJXCY,     --17 是否投向知识产权密集型产业
     ZSCQMJXCYMC,       --18 知识产权密集型产业名称
     TXSZJJHXCYDL,      --19 投向数字经济核心产业大类
     SZJJHXCYMC,        --20 数字经济核心产业名称
     SFTXSZJJHXCYDL,    --21 是否投向数字经济核心产业大类
     TXZLXXXCYXL,       --22 投向战略性新兴产业小类名称
     TXZLXXXCYML,       --23 投向战略性新兴产业门类
     ZYXXXCYMC,         --24 战略性新兴产业名称
     TXWHJXGCYXL,       --25 投向文化及相关产业小类名称
     SFTXWHCYDL,        --26 是否投向文化产业大类
     WHCYMC,            --27 文化产业名称
     SFGYQYJSGZSJDK,    --28 是否工业企业技术改造升级贷款
     TXSFJW,            --29 投向是否境外
     SFTXJNHBML,        --30 是否投向节能环保门类
     SFTXXYDXXJSML,     --31 是否投向新一代信息技术门类
     SFTXSWML,          --32 是否投向生物门类
     SFTXGDZBZZML,      --33 是否投向高端装备制造门类
     SFTXXNYML,         --34 是否投向新能源门类
     SFTXXCLML,         --35 是否投向新材料门类
     SFTXXNYQCML,       --36 是否投向新能源汽车门类
     SFTXSZCYML,        --37 是否投向数字创意门类
     SFTXXGFWML,        --38 是否投向相关服务门类
     DBFSNBKJ,          --39 担保方式内部口径
     SFFDB,             --40 是否反担保
     SFWHBXD,           --41 是否无还本续贷
     SFXHD,             --42 是否循环贷
     SFYSHZ,            --43 是否银税合作
     SFGTQY,            --44 是否关停企业
     DKCZFCFS,          --45 贷款财政扶持方式
     SFNYCYHLTQY,       --46 是否农业产业化龙头企业
     SFYQ,              --47 是否延期
     SFWLCZGSCP,        --48 是否为理财子公司产品
     SYS_SOURCE,        --49 来源系统
     SFGXRBZ,           --50 是否关系人保证
     SFCZ,              --51 是否重组
     KHZBKHJLKHH,       --52 客户主办客户经理客户号
     KHZBGYH,           --53 客户主办柜员号
     KHZBKHJLMC,        --54 客户主办客户经理名称
     KHZBKHJLSSJG,      --55 客户主办客户经理所属机构
     JJZBKHJLH,         --56 借据主办客户经理号
     JJZBGYH,           --57 借据主办柜员号
     JJZBKHJLMC,        --58 借据主办客户经理名称
     JJZBKHJLSSJG,      --59 借据主办客户经理所属机构
     DHZCHSHJE,         --60 调回正常后收回金额
     SFTXWHJXGCY,       --61 是否投向文化及相关产业
     DKCRJE,            --62 贷款承诺金额（元）
     SFTXSZCPZZY,       --63 是否投向数字产品制造业
     SFSZCPFWY,         --64 是否数字产品服务业
     SFSZCPYYYW,        --65 是否数字产品应用业务
     SFSZYSQDY,         --66 是否数字要素驱动业
     TXSZJJHXCYZL,      --67 投向数字经济核心产业中类
     SFWJY,             --68 是否玩具业
     WJHYMC,            --69 玩具业行业名称
     SFZFZDXM,          --70 是否政府重点项目
     SFSQQY,            --71 是否涉侨企业
     GYLRZQY,           --72 供应链融资企业
     SFTXHSFDCY,        --73 是否投向海上风电产业
     SFTXXXCNCY,        --74 是否投向新型储能产业
     SFZJTXZXQY,        --75 是否专精特新中小企业      --MODIFY BY YJY IN 20240219
     SFJGMDZDZJTXZXQY,  --76 是否监管名单中的专精特新中小企业       --MODIFY BY YJY IN 20240219
     SFYLCY,             --77 是否养老产业
     SFTXZFHSHZBHZ_PPP_XM, --78 是否投向政府和社会资本合作（PPP）项目
     SFXJZFFDK,         --79 是否新机制发放贷款
     SFYZLLDLYQWJFXM,    --50 是否因资金链断裂导致的逾期未交付项目
     SFYZLLDLYQWJFXMKFRZ,--51 是否因资金链断裂导致的逾期未交付项目_开发融资
     SFYZLLDLYQWJFXMKFRZDK--52 是否因资金链断裂导致的逾期未交付项目_开发融资_贷款
    )
   SELECT /*+ PARALLEL(T1,4),PARALLEL(T2,4) */
     A.DATA_DATE AS DATA_DATE,       --01 数据日期
     A.ACCT_ORG_NUM AS ACCT_ORG_NUM, --02 账务机构编号
     A.JYWYM AS JYWYM,               --03 交易唯一码
     A.ZHWYM AS ZHWYM,               --04 账户唯一码
     A.KHWYM AS KHWYM,               --05 客户唯一码
     A.KHMC AS KHMC,                 --06 客户名称
     A.PJBH AS PJBH,                 --07 票据编号
     A.JBJGMC AS JBJGMC,             --08 经办机构名称
     A.JBJGJGSZXZQHDM AS JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码
     A.ZWJGMC AS ZWJGMC,                  --10 账务机构名称
     A.ZWJGJGSZXZQHDM AS ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码
     T2.STD_PROD_ID AS DKPZMC,            --12 贷款品种名称
     NVL(B.TXGTJCYML,A.TXGTJCYML) AS TXGTJCYML,              --13 投向高技术产业门类
     NVL(A.SFTXGJSCY,B.SFTXGJSCY) AS SFTXGJSCY,              --14 是否投向高技术产业
     NVL(B.TXGJSZZYDLMC,A.TXGJSZZYDLMC) AS TXGJSZZYDLMC,     --15 投向高技术制造业大类
     NVL(B.GJSCYMC,A.GJSCYMC) AS GJSCYMC,                    --16 高技术产业名称
     A.SFTXZSCQMJXCY                      AS SFTXZSCQMJXCY,  --17 是否投向知识产权密集型产业
     A.ZSCQMJXCYMC                        AS ZSCQMJXCYMC,     --18 知识产权密集型产业名称
     NVL(A.TXSZJJHXCYDL,B.TXSZJJHXCYDL) AS TXSZJJHXCYDL,     --19 投向数字经济核心产业大类
     NVL(A.SZJJHXCYMC,B.SZJJHXCYMC) AS SZJJHXCYMC,           --20 数字经济核心产业名称
     CASE WHEN A.TXSZJJHXCYDL IN ('01','02','03','04','05') THEN 'Y'
     ELSE 'N' END AS SFTXSZJJHXCYDL,      --21 是否投向数字经济核心产业大类
     NULL AS TXZLXXXCYXL,                 --22 投向战略性新兴产业小类名称     ADD取消，M_ADD不加工
     NVL(A.TXZLXXXCYML,B.TXZLXXXCYML) AS TXZLXXXCYML,      --23 投向战略性新兴产业门类
     NVL(A.ZYXXXCYMC,B.ZYXXXCYMC) AS ZYXXXCYMC,            --24 战略性新兴产业名称
     NULL AS TXWHJXGCYXL,                 --25 投向文化及相关产业小类名称     ADD取消，M_ADD不加工
     NVL(A.SFTXWHCYDL,B.SFTXWHCYDL) AS SFTXWHCYDL,         --26 是否投向文化产业大类
     NVL(A.WHCYMC,B.WHCYMC) AS WHCYMC,                     --27 文化产业名称
     NVL(A.SFGYQYJSGZSJDK,B.SFGYQYJSGZSJDK) AS SFGYQYJSGZSJDK,  --28 是否工业企业技术改造升级贷款
     CASE WHEN T2.OVERS_LOAN_FLG = '1' THEN 'Y'
     ELSE 'N' END AS TXSFJW,              --29 投向是否境外
     CASE WHEN  A.ZYXXXCYMC = '节能环保产业' THEN 'Y'
     ELSE 'N' END AS SFTXJNHBML,          --30 是否投向节能环保门类
     CASE WHEN  A.ZYXXXCYMC = '新一代信息技术产业' THEN 'Y'
     ELSE 'N' END AS SFTXXYDXXJSML,       --31 是否投向新一代信息技术门类
     CASE WHEN  A.ZYXXXCYMC = '生物产业' THEN 'Y'
     ELSE 'N' END AS SFTXSWML,            --32 是否投向生物门类
     CASE WHEN A.ZYXXXCYMC = '高端装备制造产业' THEN 'Y'
     ELSE 'N' END AS SFTXGDZBZZML,        --33 是否投向高端装备制造门类
     CASE WHEN A.ZYXXXCYMC = '新能源产业' THEN 'Y'
     ELSE 'N' END AS SFTXXNYML,           --34 是否投向新能源门类
     CASE WHEN A.ZYXXXCYMC = '新材料产业' THEN 'Y'
     ELSE 'N' END AS SFTXXCLML,           --35 是否投向新材料门类
     CASE WHEN A.ZYXXXCYMC = '新能源汽车产业' THEN 'Y'
     ELSE 'N' END AS SFTXXNYQCML,         --36 是否投向新能源汽车门类
     CASE WHEN A.ZYXXXCYMC = '数字创意产业' THEN 'Y'
     ELSE 'N' END AS SFTXSZCYML,          --37 是否投向数字创意门类
     CASE WHEN A.ZYXXXCYMC = '相关服务业' THEN 'Y'
     ELSE 'N' END AS SFTXXGFWML,          --38 是否投向相关服务门类
     CASE WHEN T2.GUAR_WAY_CD = 'A' THEN '0'--质押'
          WHEN T2.GUAR_WAY_CD = 'B' THEN '1'--抵押'
          WHEN T2.GUAR_WAY_CD = 'D' THEN '3'--信用'
          WHEN T2.GUAR_WAY_CD = 'C' THEN '2'--保证'
     END AS DBFSNBKJ,                     --39 担保方式内部口径
     NULL AS SFFDB,                       --40 是否反担保                   ADD取消，M_ADD不加工
     DECODE(T3.LOAN_HAPP_TYPE_CD, '811', 'Y' , 'N') AS SFWHBXD,        --41 是否无还本续贷
     CASE WHEN T2.STD_PROD_ID IN ('203010100002','203010500001') --产品编号为随兴贷、法人透支
            OR T2.DUBIL_ID LIKE 'XB%'
            OR T2.DUBIL_ID LIKE 'KSW%'
          THEN 'Y'
     ELSE 'N' END AS SFXHD,               --42 是否循环贷
     NVL(B.SFYSHZ,A.SFYSHZ) AS SFYSHZ,                  --43 是否银税合作
     CASE WHEN T4.CUST_ID = '5000050641' THEN 'N' -- 该客户默认为'N'
          WHEN T4.CORP_CLOSE_FLG = '1' THEN 'Y'
     ELSE 'N' END AS SFGTQY,              --44 是否关停企业
     CASE WHEN T3.LOAN_FIN_SUPT_WAY_CD LIKE 'B01%' THEN 'B01' --B01:贴息
     END AS DKCZFCFS,                     --45 贷款财政扶持方式
     NVL(B.SFNYCYHLTQY,A.SFNYCYHLTQY) AS SFNYCYHLTQY,        --46 是否农业产业化龙头企业
     NVL(B.SFYQ,A.SFYQ) AS SFYQ,                      --47 是否延期
     'N' AS SFWLCZGSCP,                   --48 是否为理财子公司产品
     A.SYS_SOURCE AS SYS_SOURCE,          --49 来源系统
     NVL(B.SFGXRBZ,A.SFGXRBZ) AS SFGXRBZ,                --50 是否关系人保证
     CASE WHEN T3.LOAN_HAPP_TYPE_CD IN ('0201','0202','0204') THEN 'Y'
          --MOD BY LIUYU 20230614 0201展期 0202借新还旧 0204债务重组
          ELSE 'N' END AS SFCZ,                --51 是否重组
     A.KHZBKHJLKHH AS KHZBKHJLKHH,        --52 客户主办客户经理客户号
     A.KHZBGYH AS KHZBGYH,                --53 客户主办柜员号
     A.KHZBKHJLMC AS KHZBKHJLMC,          --54 客户主办客户经理名称
     A.KHZBKHJLSSJG AS KHZBKHJLSSJG,      --55 客户主办客户经理所属机构
     A.JJZBKHJLH AS JJZBKHJLH,            --56 借据主办客户经理号
     A.JJZBGYH AS JJZBGYH,                --57 借据主办柜员号
     A.JJZBKHJLMC AS JJZBKHJLMC,          --58 借据主办客户经理名称
     A.JJZBKHJLSSJG AS JJZBKHJLSSJG,      --59 借据主办客户经理所属机构
     NULL AS DHZCHSHJE,         --60 调回正常后收回金额                      ADD取消，M_ADD不加工
     NULL AS SFTXWHJXGCY,       --61 是否投向文化及相关产业                  ADD取消，M_ADD不加工
     NULL AS DKCRJE,            --62 贷款承诺金额（元）                      ADD取消，M_ADD不加工
     NULL AS SFTXSZCPZZY,       --63 是否投向数字产品制造业                  ADD取消，M_ADD不加工
     NULL AS SFSZCPFWY,         --64 是否数字产品服务业                      ADD取消，M_ADD不加工
     NULL AS SFSZCPYYYW,        --65 是否数字产品应用业务                    ADD取消，M_ADD不加工
     NULL AS SFSZYSQDY,         --66 是否数字要素驱动业                      ADD取消，M_ADD不加工
     CASE WHEN B.TXSZJJHXCYDL IS NOT NULL THEN DECODE(B.TXSZJJHXCYDL,'01','数字产品制造业'
                              ,'02','数字产品服务业'
                              ,'03','数字技术应用业'
                              ,'04','数字要素驱动业'
                              ,'05','数字化效率提升业'
                              ,'06','不适用'
                              ,B.TXSZJJHXCYDL)
          WHEN A.TXSZJJHXCYDL IS NOT NULL THEN DECODE(A.TXSZJJHXCYDL,'01','数字产品制造业'
                              ,'02','数字产品服务业'
                              ,'03','数字技术应用业'
                              ,'04','数字要素驱动业'
                              ,'05','数字化效率提升业'
                              ,'06','不适用'
                              ,A.TXSZJJHXCYDL)
     END AS TXSZJJHXCYZL,       --67 投向数字经济核心产业中类 modify by lwb 20230822
     NVL(B.SFWJY,A.SFWJY) AS SFWJY,                     --68 是否玩具业
     NVL(B.WJHYMC,A.WJHYMC) AS WJHYMC,                  --69 玩具业行业名称
     NVL(B.SFZFZDXM,A.SFZFZDXM) AS SFZFZDXM,            --70 是否政府重点项目
     NVL(B.SFSQQY,A.SFSQQY) AS SFSQQY,                  --71 是否涉侨企业
     NVL(B.GYLRZQY,A.GYLRZQY) AS GYLRZQY,               --72 供应链融资企业
     NVL(B.SFTXHSFDCY,A.SFTXHSFDCY) AS SFTXHSFDCY,      --73 是否投向海上风电产业
     NVL(B.SFTXXXCNCY,A.SFTXXXCNCY) AS SFTXXXCNCY,      --74 是否投向新型储能产业
     NVL(B.SFZJTXZXQY,A.SFZJTXZXQY) AS SFZJTXZXQY,      --75 是否专精特新中小企业         --MODIFY BY YJY IN 20240219
     NVL(B.SFJGMDZDZJTXZXQY,A.SFJGMDZDZJTXZXQY)  AS SFJGMDZDZJTXZXQY,   --76 是否监管名单中的专精特新中小企业       --MODIFY BY YJY IN 20240219
     NVL(A.SFYLCY,B.SFYLCY) AS SFYLCY,                   --77 是否养老产业
     NVL(A.SFTXZFHSHZBHZ_PPP_XM,B.SFTXZFHSHZBHZ_PPP_XM) AS SFTXZFHSHZBHZ_PPP_XM, --78 是否投向政府和社会资本合作（PPP）项目
     NVL(A.SFXJZFFDK,B.SFXJZFFDK)   AS SFXJZFFDK,         --79 是否新机制发放贷款
     NVL(B.SFYZLLDLYQWJFXM,A.SFYZLLDLYQWJFXM)   AS SFYZLLDLYQWJFXM,    --50 是否因资金链断裂导致的逾期未交付项目
     NVL(B.SFYZLLDLYQWJFXMKFRZ,A.SFYZLLDLYQWJFXMKFRZ),--51 是否因资金链断裂导致的逾期未交付项目_开发融资
     NVL(B.SFYZLLDLYQWJFXMKFRZDK,A.SFYZLLDLYQWJFXMKFRZDK) --52 是否因资金链断裂导致的逾期未交付项目_开发融资_贷款
   FROM ADD_DG_003_MONEY A
   LEFT JOIN TMP_M_ADD_DG_003_MONEY B
   ON A.JYWYM = B.JYWYM
   LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T2  --对公贷款借据信息表
          ON A.JYWYM = T2.DUBIL_ID
         AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T3   --对公贷款合同信息表
          ON T2.CONT_ID = T3.CONT_ID
         AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T4  --对公客户基本信息表
          ON T2.CUST_ID = T4.CUST_ID
         AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.CODE ORDER BY T.S_CORE) RN FROM M_DICT_G0107_REMAPPING_BL T WHERE T.TYPE_CODE = 'G010702') T10--数字经济核心产业
          ON T2.DIR_INDUS_CD = T10.CODE
         AND T10.RN = 1
   LEFT JOIN M_INDUSTRY_CLASSIFY T11
          ON T2.DIR_INDUS_CD = T11.INDUS_CATE_CD
         AND T11.CLASSIFY = '战略新兴'
   LEFT JOIN  (SELECT DISTINCT CYML,CODE,NAME,SFDX,SFDZBSY FROM M_DICT_G19_REMAPPING_BL WHERE TYPE_CODE = 'G1902' AND SFDZBSY = 'N') T11_1
          ON T3.DIR_INDUS_CD = T11_1.CODE
   LEFT JOIN  (SELECT DISTINCT CODE,NAME,SFDX,SFDZBSY FROM M_DICT_G19_REMAPPING_BL WHERE TYPE_CODE = 'G1902' AND SFDZBSY = 'Y') T11_2
          ON T3.DIR_INDUS_CD = T11_2.CODE
   LEFT JOIN (SELECT DISTINCT T.CODE,T.NAME,T.S_CORE,T.S_NAME,T.SFDX FROM M_DICT_G19_REMAPPING_BL T WHERE T.TYPE_CODE = 'G1901') T12 --文化及相关产业
          ON T2.DIR_INDUS_CD = T12.CODE
   WHERE A.DATA_DATE = V_P_DATE
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP      := 4;
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
      FROM RRP_MDL.M_ADD_DG_003_MONEY T
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
   V_STEP      := 5;
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
EXCEPTION
   WHEN OTHERS THEN
     V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE   := '1';
     V_ENDTIME   := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_ADD_DG_003_MONEY;
/

