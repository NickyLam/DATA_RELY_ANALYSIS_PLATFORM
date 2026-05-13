CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_GUARANTEE
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_FGB_GUARANTEE
  *  功能描述：个人及对公信贷业务中所签订的各类担保合同信息，至少包括普通担保和最高额担保合同。
                同一份担保合同有多个担保人的，每个担保人填写一条记录。填报范围包含抵质押合同。
  *  创建日期：20221109
  *  开发人员：徐菲
  *  来源表：M_GUA_COLL_VAL_SPLT A --抵质押物价值拆分表
  *  目标表：A_FGB_GUARANTEE -担保基表_对公
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221109   xufei      首次创建
  *   2    20230615   MW         新增字段贷款分配价值、分配我行确认价值、分配初评我行确认价值
  *   3    20251020   HYF        押品重构需求，调整是否新型抵质押类贷款是否知识产权质押按照新押品类型码值取值过滤
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_GUARANTEE';
                                 -- 程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME   := 'A_FGB_GUARANTEE'; --表名,写目标表表名
  V_PART_NAME  := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  ETL_PARTITION_ADD(I_P_DATE, 'A_FGB_GUARANTEE', '1', O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入主表';
  V_STARTTIME := SYSDATE;

      INSERT /*+APPEND*/ INTO A_FGB_GUARANTEE NOLOGGING
        (
                 BGRQ               --1 报告日期
                ,YPWYM              --2 押品唯一码
                ,YPXJLWYM           --3 押品现金流唯一码
                ,DYJJBH             --4 对应借据编号
                ,JGBH               --5 机构编号
                ,JGMC               --6 机构名称
                ,KHWYM              --7 客户唯一码
                ,QYGM               --8 企业规模
                ,TJDBFS             --9 担保方式
                ,YPLB               --10 押品类别
                ,YPQSGZ             --11 押品起始估值（元）
                ,YPQSGZCF           --12 押品起始估值拆分（元）
                ,YPZXGZ             --13 押品最新估值（元）
                ,YPZXGZCF           --14 押品最新估值拆分（元）
                ,TJYE               --15 统计余额（元）
                ,CFTJYE             --16 拆分统计余额（元）
                ,YPHSSX             --17 押品缓释上限（元）
                ,ZXZTPJ             --18 债项/主体评级
                ,ZXZTPJQJ           --19 债项/主体评级区间
                ,SFXXDZYLDK         --20 是否新型抵质押类贷款
                ,SFZSCQZY           --21 是否知识产权质押
                ,DKFPJZ             --22 贷款分配价值
                ,FPWHQRJZ           --23 分配我行确认价值
                ,FPCPWHQRJZ         --24 分配初评我行确认价值
          )
    SELECT A.DATA_DT                   AS BGRQ               --1 报告日期
      ,A.SCCODE                    AS YPWYM              --2 押品唯一码
      ,A.SCCODE ||'.'|| A.CREDNO   AS YPXJLWYM           --3 押品现金流唯一码
      ,A.CREDNO                    AS DYJJBH             --4 对应借据编号
      ,D.ORG_ID                    AS JGBH               --5 机构编号
      ,F.ORG_NM                    AS JGMC               --6 机构名称
      ,D.CUST_ID                   AS KHWYM              --7 客户唯一码
      ,CASE WHEN D.IS_CBRC_ENT = 'Y' THEN
                         DECODE(G.ENT_SCALE,'L','大型企业','M','中型企业','S','小型企业','X','微型企业','其他法人客户')
                            ELSE '其他法人客户'
                          END                                  AS QYGM               --8 企业规模
      ,DECODE(D.TJDBFS,'DZY','抵质押','BZ','保证','XY','信用','不适用')
                                   AS TJDBFS             --9 担保方式
      ,CASE WHEN  A.GUARTYPE<>'ZY0304001'  THEN
                             CASE WHEN B.FIELDIDX ='3'
                                       THEN '1.1现金及其等价物'            --1.1现金及其等价物
                                  WHEN B.FIELDIDX='4'
                                       THEN '1.2贵金属'                   --贵金属
                                  WHEN B.FIELDIDX='6'
                                       THEN '1.3.1国债'                   --国债
                                  WHEN B.FIELDIDX='7'
                                       THEN '1.3.2地方政府债'             --地方政府债
                                  WHEN B.FIELDIDX='8'
                                       THEN '1.3.3央票'                   --央票
                                  WHEN B.FIELDIDX='9'
                                       THEN '1.3.4政府机构债券'           --1.3.4政府机构债券（新增映射）
                                  WHEN B.FIELDIDX='10'
                                       THEN '1.3.5政策性金融债'           --政策性金融债
                                  WHEN B.FIELDIDX='11'
                                       THEN '1.3.6商业性金融债'           --商业性金融债
                                  WHEN B.FIELDIDX='16'
                                       THEN '1.3.8其他债券'               --其他债券
                                  WHEN B.FIELDIDX='17'
                                       THEN '1.4票据'                     --票据
                                  WHEN B.FIELDIDX='19'
                                       THEN '1.5.1上市股票'               --上市股票
                                  WHEN B.FIELDIDX='20'
                                       THEN '1.5.2非上市股权'             --非上市股权
                                  WHEN B.FIELDIDX='21'
                                       THEN '1.5.3基金'                   --基金
                                  WHEN B.FIELDIDX='22'
                                       THEN '1.6保单'                     --保单
                                  WHEN B.FIELDIDX='23'
                                  THEN '1.7资产管理产品（不含公募基金）'  --资产管理产品（不含公募基金）
                                  WHEN B.FIELDIDX='24'
                                       THEN '1.8其他金融质押品'          --其他金融质押品
                                  WHEN B.FIELDIDX='26'
                                       THEN '2.1普通应收账款'            --普通应收账款
                                  WHEN B.FIELDIDX='27'
                                       THEN '2.2各类收费权'              --各类收费权
                                  WHEN B.FIELDIDX='28'
                                       THEN '2.3其他应收账款'            --其他应收账款
                                  WHEN B.FIELDIDX='30'
                                       THEN '3.1居住用房地产'            --居住用房地产
                                  WHEN B.FIELDIDX='31'
                                       THEN '3.2经营性房地产'            --经营性房地产
                                  WHEN B.FIELDIDX='32'
                                  THEN '3.3居住用房地产建设用地使用权'   --居住用房地产建设用地使用权
                                  WHEN B.FIELDIDX='33'
                                  THEN '3.4经营性房地产建设用地使用权'   --经营性房地产建设用地使用权
                                  WHEN B.FIELDIDX='34'
                                       THEN '3.5房产类在建工程'           --房产类在建工程
                                  WHEN B.FIELDIDX='35'
                                       THEN '3.6其他房地产类押品'         --其他房地产类押品   --ADD BY HAP 20210617
                                  WHEN B.FIELDIDX='37'
                                       THEN '4.1存货、仓单和提单'         --存货、仓单和提单
                                  WHEN B.FIELDIDX='38'
                                       THEN '4.2机器设备'                 --机器设备
                                  WHEN B.FIELDIDX='40'
                                       THEN '4.3.1车辆'                   --车辆
                                  WHEN B.FIELDIDX='41'
                                       THEN '4.3.2飞行器'                 --飞行器
                                  WHEN B.FIELDIDX='42'
                                       THEN '4.3.3船舶'                   --船舶
                                  WHEN B.FIELDIDX='43'
                                  THEN '4.3.4其他交通运输设备'            --其他交通运输设备
                                  WHEN B.FIELDIDX='44'
                                      THEN '4.4资源资产'                  --资源资产
                                  WHEN B.FIELDIDX='46'
                                      THEN '4.5.1专利权'                  --专利权
                                  WHEN B.FIELDIDX='47'
                                      THEN '4.5.2商标权'                  --商标权
                                  WHEN B.FIELDIDX='48'
                                      THEN '4.5.3著作权'                  --著作权
                                  WHEN B.FIELDIDX='49'
                                  THEN '4.5.4其他知识产权'                --4.5.4其他知识产权(新增映射)
                                  WHEN B.FIELDIDX='50'
                                      THEN '4.6其他以上未包括的押品'      --其他以上未包括的押品

                                  END
            ELSE    CASE WHEN   E.RATING_REST_CD IN ('AA+','AAA','AAA-','AAA+')
                            THEN 'A030701'         --评级在AA+（含）以上
                         WHEN  E.RATING_REST_CD IN ('AA-','A+','A','A-','AA')
                            THEN 'A030702'         --评级在AA+至A之间
                         WHEN  E.RATING_REST_CD IN ('BBB+','BBB','BBB-','BB+','BB','BB-','B+','B','B-','C','CC','CCC')
                            THEN 'A030703'         --评级在A以下或无评级
                     END
            END                                 AS YPLB               --10 押品类别
      ,A.HXB_PA_CFM_VAL                         AS YPQSGZ             --11 押品起始估值（元）
      ,A.FIRSTCONFMAMT                          AS YPQSGZCF           --12 押品起始估值拆分（元）
      ,A.ESTIM_VAL                              AS YPZXGZ             --13 押品最新估值（元）
      ,A.CONFMAMT                               AS YPZXGZCF           --14 押品最新估值拆分（元）
      ,A.LOAN_NET_VAL                           AS TJYE               --15 统计余额（元）
      ,A.DISTVALUE                              AS CFTJYE             --16 拆分统计余额（元）
      ,CASE WHEN NVL(A.CONFMAMT,0) <> NVL(A.LOAN_NET_VAL,0) THEN NVL(A.LOAN_NET_VAL,0)
            ELSE 0
       END                                      AS YPHSSX             --19 押品缓释上限（元）
      ,''                                       AS ZXZTPJ             --20 债项/主体评级                --缺字段
      ,''                                       AS ZXZTPJQJ           --21 债项/主体评级区间             --缺字段
/*     ,CASE WHEN C.COL_TYPE_ID IN ('ZY0501001','ZY0501002','ZY0501003','ZY0501004','ZY0501005','ZY0501006','ZY0501007','ZY0501008','ZY0501009','ZY0501010','ZY0501011','ZY0501012','ZY0502001'
                                 ,'ZY0503001','ZY0599001','DY0101001','DY0101002','DY0101003','DY0101999','DY0102001','DY0102002','DY0102003','DY0102004','DY0102005','DY0102006','DY0102007','DY0102008',
                                 'DY0102009','DY0102999','DY0103001','DY0103002','DY0103003','DY0103004','DY0103005','DY0103006','DY0103007','DY0103008','DY0103009','DY0103010',
                                 'DY0103011','DY0103012','DY0103013','DY0103014','DY0103999','DY0104001','DY0104002','DY0104003','DY0104004','DY0104005','DY0104006','DY0104999',
                                 'DY0105001','DY0105002','DY0105003','DY0105004','DY0105005','DY0105006','DY0105007','DY0105008','DY0105009','DY0105010','DY0105011','DY0105999',
                                 'DY0106001','DY0106002','DY0106003','DY0106004','DY0106999','DY0107001','DY0107002','DY0107003','DY0107004','DY0107005','DY0107006','DY0107007',
                                 'DY0107008','DY0108001','DY0108002','DY0108003','DY0108004','DY0108999','DY0109001','DY0109002','DY0110001','DY0110002','DY0110003','DY0111001',
                                 'DY0111002','DY0111003','DY0111004','DY0111005','DY0111006','DY0111007','DY0111008','DY0111009','DY0111010','DY0111999','DY0112001','DY0112002',
                                 'DY0112999','DY0113001','DY0113002','DY0113003','DY0113004','DY0113005','DY0113006','DY0113007','DY0113008','DY0113999','DY0114001','DY0114002',
                                 'DY0114003','DY0114999','DY0115001','DY0115002','DY0115003','DY0115004','DY0115005','DY0115999','DY0116001','DY0116002','DY0116003','DY0116004',
                                 'DY0116005','DY0116999','DY0117001','DY0117002','DY0117999','DY0118001','DY0118002','DY0118003','DY0118999','DY0119001','DY0119002','DY0119003',
                                 'DY0119004','DY0119005','DY0119006','DY0119007','DY0119008','DY0119999','DY0120001','DY0120002','DY0120003','DY0120999','ZY0701001','ZY0701002',
                                 'ZY0701003','ZY0701999','ZY0702001','ZY0702002','ZY0702003','ZY0702004','ZY0702005','ZY0702006','ZY0702007','ZY0702008','ZY0702009','ZY0702999',
                                 'ZY0703001','ZY0703002','ZY0703003','ZY0703004','ZY0703005','ZY0703006','ZY0703007','ZY0703008','ZY0703009','ZY0703010','ZY0703011','ZY0703012',
                                 'ZY0703013','ZY0703014','ZY0703999','ZY0704001','ZY0704002','ZY0704003','ZY0704004','ZY0704005','ZY0704006','ZY0704999','ZY0705001','ZY0705002',
                                 'ZY0705003','ZY0705004','ZY0705005','ZY0705006','ZY0705007','ZY0705008','ZY0705009','ZY0705010','ZY0705011','ZY0705999','ZY0706001','ZY0706002',
                                 'ZY0706003','ZY0706004','ZY0706999','ZY0707001','ZY0707002','ZY0707003','ZY0707004','ZY0707005','ZY0707006','ZY0707007','ZY0707008','ZY0708001',
                                 'ZY0708002','ZY0708003','ZY0708004','ZY0708999','ZY0709001','ZY0709002','ZY0710001','ZY0710002','ZY0710003','ZY0711001','ZY0711002','ZY0711003',
                                 'ZY0711004','ZY0711005','ZY0711006','ZY0711007','ZY0711008','ZY0711009','ZY0711010','ZY0711999','ZY0712001','ZY0712002','ZY0712999','ZY0713001',
                                 'ZY0713002','ZY0713003','ZY0713004','ZY0713005','ZY0713006','ZY0713007','ZY0713008','ZY0713999','ZY0714001','ZY0714002','ZY0714003','ZY0714999',
                                 'ZY0715001','ZY0715002','ZY0715003','ZY0715004','ZY0715005','ZY0715999','ZY0716001','ZY0716002','ZY0716003','ZY0716004','ZY0716005','ZY0716999',
                                 'ZY0717001','ZY0717002','ZY0717999','ZY0718001','ZY0718002','ZY0718003','ZY0718999','ZY0719001','ZY0719002','ZY0719003','ZY0719004','ZY0719005',
                                 'ZY0719006','ZY0719007','ZY0719008','ZY0719999','ZY0720001','ZY0720002','ZY0720003','ZY0720999','ZY0801001','ZY0801002','ZY0801003','ZY0801004',
                                 'ZY0801005','ZY0801006','ZY0801007','ZY0801008','ZY0801009','ZY0801010','ZY0801011','ZY0801012','ZY0801013','ZY0801014','ZY0801999','ZY0802001',
                                 'ZY0802002','ZY0802003','ZY0802004','ZY0802005','ZY0802006','ZY0802007','ZY0802008','ZY0802009','ZY0802010','ZY0802011','ZY0802012','ZY0802013',
                                 'ZY0802014','ZY0802015','ZY0802016','ZY0802999','ZY0803001','ZY0803002','ZY0803003','ZY0803004','ZY0803005','ZY0803006','ZY0803007','ZY0803008',
                                 'ZY0803009','ZY0803010','ZY0803011','ZY0803012','ZY0803013','ZY0803014','ZY0803015','ZY0803999','ZY0804999','ZY0901001','ZY1001001','ZY0603002',
                                 'ZY9902001','ZY9902002','ZY0603001','ZY0603003')
                     --上市股票，非上市股权 ，存货、仓单和提单，专利权 保单 商标权 著作权 其他知识产权*/
     ,CASE WHEN B.FIELDIDX IN ('19','20','22','37','46','47','48','49' )               
           THEN '是'
           ELSE '否'
      END                                       AS SFXXDZYLDK         --22 是否新型抵质押类贷款
     --,CASE WHEN C.COL_TYPE_ID IN ('ZY0603002','ZY0603001','ZY0603003')
     ,CASE WHEN C.COL_TYPE_ID IN ('90050010010','90050020010','90050030010')
           THEN '是'
           ELSE '否'
      END                                       AS SFZSCQZY           --24 是否知识产权质押
     ,A.DISTVALUE_YP                            AS DKFPJZ             --22 贷款分配价值
     ,A.CONFMAMT_YP                             AS FPWHQRJZ           --23 分配我行确认价值
     ,A.FIRSTCONFMAMT_YP                        AS FPCPWHQRJZ         --24 分配初评我行确认价值
  FROM S_G13_BASE A --G13贷款押品分配结果表
  LEFT JOIN RRP_MDL.O_IOL_MIMS_YP_G13RELATION B --G13报表分配关系明细表
    ON B.GUARTYPE = A.GUARTYPE
   --AND B.GUARTYPE <> 'ZY0304001' --该押品类型存在重复，放到过程后面单独处理
   AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
  LEFT JOIN RRP_MDL.M_GUA_COLL_INFO C --抵质押物详细信息
    ON C.COLL_ID = A.SCCODE
   AND C.DATA_DT = A.DATA_DT
  LEFT JOIN RRP_MDL.S_LOAN D ----贷款业务整合表
    ON D.RCPT_ID = A.CREDNO
   AND D.DATA_DT = A.DATA_DT
   AND D.DATA_SRC = '对公信贷'
  LEFT JOIN (SELECT DISTINCT BOND_ID, RATING_REST_CD
               FROM RRP_MDL.O_ICL_CMM_BOND_RATING_INFO --债券评级信息
              WHERE ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')) E
    ON E.BOND_ID = A.SCCODE
  LEFT JOIN RRP_MDL.M_PUM_ORG_INFO F --机构表
    ON F.ORG_ID = D.ORG_ID
   AND F.DATA_DT = A.DATA_DT
  LEFT JOIN RRP_MDL.M_CUST_CORP_INFO G --对公客户信息
    ON G.CUST_ID = D.CUST_ID
   AND G.DATA_DT = A.DATA_DT
 WHERE A.BALANCE_TYPE = '表内'
   AND A.DATA_SRC = '对公信贷'
      -- AND A.GUA_TYPE='抵质押'
      -- AND A.GUARTYPE='ZY0304001'
   AND A.DATA_DT = V_P_DATE;
  COMMIT;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,YPXJLWYM,COUNT(1)
      FROM RRP_MDL.A_FGB_GUARANTEE T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,YPXJLWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;
   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
--插入过程跑批完成记录表
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
     V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_A_FGB_GUARANTEE;
/

