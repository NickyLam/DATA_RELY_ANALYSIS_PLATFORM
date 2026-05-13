CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_G12_MIGRATE
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
/**************************************************************************
  *  程序名称：ETL_A_FGB_G12_MIGRATE
  *  功能描述：对公-贷款迁徙模型（G12）
  *  创建日期：20221107
  *  开发人员：WYX
  *  来源表：
  *  目标表：A_FGB_G12_MIGRATE           --对公-贷款迁徙模型（G12）
  *  配置表：
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221031   WYX        首次创建
  *   2    20230329   Liuyu      重写逻辑
  *根据荣炳华口径：
    借款人现金偿还金额:处置方式=现金收回、直接催收、司法清收   取处置金额
    第三方现金代偿金额:处置方式=第三方代偿
    个贷单户转让收现： 判断资产转让类型=单户转让， 客户类型=个人客户  处置方式=资产转让
    个贷批量转让收现： 判断资产转让类型=批量转让， 客户类型=个人客户  处置方式=资产转让
    对公批量转让收现： 判断资产转让类型=批量转让， 客户类型=公司客户  处置方式=资产转让
    非转让核销：处置方式=全额核销/呆账核销
    个贷单户转让损失核销： 判断客户类型=个人客户 ，资产转让类型=单户转让  处置方式=差额核销
    个贷批量转让损失核销： 判断客户类型=个人客户 ，资产转让类型=批量转让  处置方式=差额核销
    对公批量转让损失核销： 判断客户类型=公司客户 ，资产转让类型=批量转让  处置方式=差额核销
    以物抵债不含债转股： 判断处置方式=以物抵债
    以股抵债：判断处置方式=债转股
    其他处置：处置方式=资产证券化
     3     20230508   liuyu     新增机构号字段用于G12报表出数
     4     20230524   liuyu     新增迁徙记录的过滤条件，只要本年的和上年末有余额的借据
***************************************************************************/
 AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_G12_MIGRATE';   --程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME   VARCHAR2(100) ; --表名
  V_PART_NAME  VARCHAR2(100); --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'A_FGB_G12_MIGRATE'; --表名,写目标表表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

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

  ETL_PARTITION_ADD(V_P_DATE, 'A_FGB_G12_MIGRATE', '1', O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据插入G12贷款迁徙表-资产保全部分';
  V_STARTTIME := SYSDATE;

  INSERT INTO A_FGB_G12_MIGRATE
  (
    DATA_SRC	        --01 数据来源
   ,BGRQ	            --02 报告日期
   ,JYWYM	            --03 交易唯一码
   ,WJFLXJLWYM	      --04 五级分类现金流唯一码
   ,NCWJFL	          --05 年初五级分类
   ,NCSFBL	          --06 年初是否不良
   ,BDQWJFL	          --07 变动前五级分类
   ,BDQSFBL		        --08 变动前是否不良
   ,ZCSXJE	          --09 正常收现金额（元）
   ,JKRXJCHJE	        --10 借款人现金偿还金额（元）
   ,DSFXJDCJE	        --11 第三方现金代偿金额（元）
   ,GDDHZRSX	        --12 个贷单户转让收现（元）
   ,GDPLZRSX	        --13 个贷批量转让收现（元）
   ,DGDHZRSX	        --14 对公单户转让收现（元）
   ,DGPLZRSX	        --15 对公批量转让收现（元）
   ,FZRHX	            --16 非转让核销（元）
   ,GDDHZRSSHX	      --17 个贷单户转让损失核销（元）
   ,GDPLZRSSHX	      --18 个贷批量转让损失核销（元）
   ,DGDHZRSSHX	      --19 对公单户转让损失核销（元）
   ,DGPLZRSSHX	      --20 对公批量转让损失核销（元）
   ,YWDZBHZZG	        --21 以物抵债不含债转股（元）
   ,YGDZ	            --22 以股抵债（元）
   ,QTCZ	            --23 其他处置（元）
   ,JSJEHJ	          --24 减少金额合计（元）
   ,ZJJE	            --25 增加金额（元）
   ,BDHWJFL	          --26 变动后五级分类
   ,BDHSFBL	          --27 变动后是否不良
   ,TJYE	            --28 统计余额（元）
   ,QMWJFL	          --29 期末五级分类
   ,QMSFBL	          --30 期末是否不良
   ,CZBS	            --31 重组标识
   ,STHXT	            --32 上调或下调
   ,DKQXFS	          --33 贷款迁徙方式
   ,ZBZHJ	            --34 债变债合计（元）
   ,FCZXTJE	          --35 非重组下调金额（元）
   ,FCZSTJE	          --36 非重组上调金额（元）
   ,BNCZXTJE	        --37 本年重组下调金额（元）
   ,BNCZSTJE	        --38 本年重组上调金额（元）
   ,WNCZXTJE	        --39 往年重组下调金额（元）
   ,WNCZSTJE	        --40 往年重组上调金额（元）
   ,SCFCZSTJE	        --41 首次非重组上调金额（元）
   ,SCFCZSTQWJFL	    --42 首次非重组上调前五级分类
   ,SCBNCZSTJE	      --43 首次本年重组上调金额（元）
   ,SCBNCZSTQWJFL	    --44 首次本年重组上调前五级分类
   ,SCWNCZSTJE	      --45 首次往年重组上调金额（元）
   ,SCWNCZSTQWJFL	    --46 首次往年重组上调前五级分类
   ,ZHWYM	            --47 账户唯一码
   ,KHWYM	            --48 客户唯一码
   ,KHMC	            --49 客户名称
   ,CZSJ              --50 资产保全处置时间
   ,BDSJ              --51 五级分类变动时间
   ,JGBH              --52 机构编号 -- add by liuyu 20230508
  )

  WITH TMP_CZBZ AS (
     /*保全台账：处置方式=债务重组、借新还旧、展期，判断该处置时点之后的所有变动均显示“重组”；
            无出现该类处置方式的，则显示“非重组”*/
   SELECT A.DUEBILLID,MIN(A.HANDLETIME) AS MINTIME
     FROM M_ASSET_PRESERVATION_LEDGET A
    WHERE A.HANDLETYPE IN ('债务重组','借新还旧','展期') --取全部的重组借据
      AND A.DATA_DT = V_P_DATE
    GROUP BY A.DUEBILLID
  )
    SELECT
           '资产保全'||B.DATA_SRC             AS DATA_SRC    --01 数据来源
          ,V_P_DATE                           AS BGRQ        --02 报告日期
          ,A.DUEBILLID                        AS JYWYM       --03 交易唯一码
          ,A.SERIALNO||A.DUEBILLID            AS WJFLXJLWYM  --04 五级分类现金流唯一码
          ,CASE
             WHEN C.LVL5_CL = '01' THEN '正常类'
             WHEN C.LVL5_CL = '02' THEN '关注类'
             WHEN C.LVL5_CL = '03' THEN '次级类'
             WHEN C.LVL5_CL = '04' THEN '可疑类'
             WHEN C.LVL5_CL = '05' THEN '损失类'
             WHEN SUBSTR(B.LOAN_ACT_DSTR_DT,1,4) = SUBSTR(V_P_DATE,1,4) THEN '本年放款不适用'
             ELSE NULL
           END                                AS NCWJFL            --05 年初五级分类
          ,CASE WHEN C.LVL5_CL IN('03','04','05') THEN '是'
                WHEN C.LVL5_CL IN('01','02') THEN '否'
                WHEN SUBSTR(B.LOAN_ACT_DSTR_DT,1,4) = SUBSTR(V_P_DATE,1,4) THEN '本年放款不适用'
                ELSE NULL
           END                               AS NCSFBL            --06 年初是否不良
          ,A.HANDLERISKCLASSIFY               AS BDQWJFL     --07 变动前五级分类
           /*变动前五级分类: 保全台账处置时点的五级分类，迁徙记录调整前的五级分类*/
          ,CASE WHEN A.HANDLERISKCLASSIFY IN('次级类','可疑类','损失类')
                THEN '是'
           ELSE '否'  END                     AS BDQSFBL     --08 变动前是否不良
          ,A.NORMALRECOVERBALANCE             AS ZCSXJE      --09 正常收现金额（元）
          /*处置方式=债务重组、借新还旧、展期，判断处置时点之后的五级分类变动，如由不良上调至非不良，则取上调时点后的回款金额，
          否则为0。*/
          ,CASE WHEN A.HANDLETYPE IN ('现金收回','直接催收','司法清收') THEN NVL(A.HANDLEBALANCE,0) ELSE 0 END
                                              AS JKRXJCHJE	 --10 借款人现金偿还金额（元）
          ,CASE WHEN A.HANDLETYPE IN ('第三方代偿') THEN NVL(A.HANDLEBALANCE,0) ELSE 0 END
                                              AS DSFXJDCJE	 --11 第三方现金代偿金额（元）
          ,CASE WHEN A.HANDLETYPE IN ('资产转让')  AND A.TYPEASSETTRANSFER = '单户转让'
                 AND A.CUSTOMERTYPE = '个人客户' THEN NVL(A.HANDLEBALANCE,0) ELSE 0 END
                                              AS GDDHZRSX	   --12 个贷单户转让收现（元）
          ,CASE WHEN A.HANDLETYPE IN ('资产转让')  AND A.TYPEASSETTRANSFER = '批量转让'
                 AND A.CUSTOMERTYPE = '个人客户' THEN NVL(A.HANDLEBALANCE,0) ELSE 0 END
                                              AS GDPLZRSX	   --13 个贷批量转让收现（元）
          ,CASE WHEN A.HANDLETYPE IN ('资产转让')  AND A.TYPEASSETTRANSFER = '单户转让'
                 AND A.CUSTOMERTYPE IN ('公司客户','对公') THEN NVL(A.HANDLEBALANCE,0) ELSE 0 END
                                              AS DGDHZRSX	   --14 对公单户转让收现（元）
          ,CASE WHEN A.HANDLETYPE IN ('资产转让')  AND A.TYPEASSETTRANSFER = '批量转让'
                 AND A.CUSTOMERTYPE IN ('公司客户','对公') THEN NVL(A.HANDLEBALANCE,0) ELSE 0 END
                                              AS DGPLZRSX	   --15 对公批量转让收现（元）
          ,CASE WHEN A.HANDLETYPE IN ('呆账核销','全额核销') THEN NVL(A.HANDLEBALANCE,0)
                ELSE 0 END                    AS FZRHX	     --16 非转让核销（元）
          ,CASE WHEN A.HANDLETYPE IN ('差额核销')  AND A.TYPEASSETTRANSFER = '单户转让'
                 AND A.CUSTOMERTYPE = '个人客户' THEN NVL(A.HANDLEBALANCE,0) ELSE 0 END
                                              AS GDDHZRSSHX	 --17 个贷单户转让损失核销（元）
          ,CASE WHEN A.HANDLETYPE IN ('差额核销')  AND A.TYPEASSETTRANSFER = '批量转让'
                 AND A.CUSTOMERTYPE = '个人客户' THEN NVL(A.HANDLEBALANCE,0) ELSE 0 END
                                              AS GDPLZRSSHX	 --18 个贷批量转让损失核销（元）
          ,CASE WHEN A.HANDLETYPE IN ('差额核销')  AND A.TYPEASSETTRANSFER = '单户转让'
                 AND A.CUSTOMERTYPE IN ('公司客户','对公') THEN NVL(A.HANDLEBALANCE,0) ELSE 0 END
                                              AS DGDHZRSSHX	 --19 对公单户转让损失核销（元）
          ,CASE WHEN A.HANDLETYPE IN ('差额核销')  AND A.TYPEASSETTRANSFER = '批量转让'
                 AND A.CUSTOMERTYPE IN ('公司客户','对公') THEN NVL(A.HANDLEBALANCE,0) ELSE 0 END
                                              AS DGPLZRSSHX	 --20 对公批量转让损失核销（元）
          ,CASE WHEN A.HANDLETYPE IN ('以物抵债') THEN NVL(A.HANDLEBALANCE,0) ELSE 0 END
                                              AS YWDZBHZZG	 --21 以物抵债不含债转股（元）
          ,CASE WHEN A.HANDLETYPE IN ('债转股') THEN NVL(A.HANDLEBALANCE,0) ELSE 0 END
                                              AS YGDZ	       --22 以股抵债（元）
          ,CASE WHEN A.HANDLETYPE NOT IN ('资产转让','差额核销','以物抵债','债转股'
                                         ,'呆账核销','全额核销'
                                         ,'债务重组','借新还旧','展期' -- MOD BY liuyu
                                         ,'现金收回','直接催收','司法清收','第三方代偿')
                                         -- mod by liuyu 20230424 荣炳华评审调整逻辑
                THEN NVL(A.HANDLEBALANCE,0) ELSE 0 END -- 资产证券化
                                              AS QTCZ	       --23 其他处置（元）
          ,NVL(A.HANDLEBALANCE,0)             AS JSJEHJ      --24 减少金额合计（元）
          ,NULL                               AS ZJJE        --25 增加金额（元）
          ,A.HANDLERISKCLASSIFY               AS BDHWJFL     --26 变动后五级分类
           /*保全台账：处置时的五级分类*/
          ,CASE WHEN A.HANDLERISKCLASSIFY IN('次级类','可疑类','损失类')
                THEN '是'
           ELSE '否'  END                     AS BDHSFBL     --27 变动后是否不良
          ,B.LOAN_NET_VAL * U.EXRT            AS TJYE        --28 统计余额（元）
          ,CASE
             WHEN B.LVL5_CL = '01' THEN '正常类'
             WHEN B.LVL5_CL = '02' THEN '关注类'
             WHEN B.LVL5_CL = '03' THEN '次级类'
             WHEN B.LVL5_CL = '04' THEN '可疑类'
             WHEN B.LVL5_CL = '05' THEN '损失类'
             ELSE '不适用'
          END                                AS QMWJFL       --29 期末五级分类
         ,CASE WHEN B.LVL5_CL IN ('03','04','05') THEN '是'
               ELSE '否'  END                AS QMSFBL       --30 期末是否不良
         ,CASE WHEN A.HANDLETYPE IN ('债务重组','借新还旧','展期') THEN '重组' --处置方式=债务重组、借新还旧、展期
               --WHEN A.HANDLETIME >= TMP1.MINTIME THEN '重组' -- 判断该处置时点之后的所有变动
               ELSE '非重组'  END            AS CZBS         --31 重组标识
         ,'不适用'                           AS STHXT        --32 上调或下调
         ,CASE WHEN A.HANDLETYPE IN ('债务重组','借新还旧','展期') THEN '重组不适用' --处置方式=债务重组、借新还旧、展期
               --WHEN A.HANDLETIME >= TMP1.MINTIME THEN '重组不适用' -- 判断该处置时点之后的所有变动
               ELSE '非重组不适用'  END
                                             AS DKQXFS       --33 贷款迁徙方式
         ,NULL                               AS ZBZHJ        --34 债变债合计（元）
         ,NULL                               AS FCZXTJE      --35 非重组下调金额（元）
         ,NULL                               AS FCZSTJE      --36 非重组上调金额（元）
         ,NULL                               AS BNCZXTJE     --37 本年重组下调金额（元）
         ,NULL                               AS BNCZSTJE     --38 本年重组上调金额（元）
         ,NULL                               AS WNCZXTJE     --39 往年重组下调金额（元）
         ,NULL                               AS WNCZSTJE     --40 往年重组上调金额（元）
         ,NULL                               AS SCFCZSTJE	   --41 首次非重组上调金额（元）
         ,NULL                               AS SCFCZSTQWJFL --42 首次非重组上调前五级分类
         ,NULL                               AS SCBNCZSTJE	 --43 首次本年重组上调金额（元）
         ,NULL                               AS SCBNCZSTQWJFL	--44 首次本年重组上调前五级分类
         ,NULL                               AS SCWNCZSTJE	 --45 首次往年重组上调金额（元）
         ,NULL                               AS SCWNCZSTQWJFL	--46 首次往年重组上调前五级分类
         ,B.CONT_ID                          AS ZHWYM        --47 账户唯一码
         ,A.CUSTOMERID                       AS KHWYM        --48 客户唯一码
         ,A.CUSTOMERNAME                     AS KHMC         --49 客户名称
         ,TO_CHAR(A.HANDLETIME,'YYYYMMDD')   AS CZSJ         --50 资产保全处置时间
         ,NULL                               AS BDSJ         --51 五级分类变动时间
         ,B.ORG_ID                           AS JGBH         --52 机构编号
    FROM RRP_MDL.M_ASSET_PRESERVATION_LEDGET A --资产保全台账
    LEFT JOIN RRP_MDL.S_LOAN B     --贷款整合表
      ON B.RCPT_ID = A.DUEBILLID
     AND B.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.S_LOAN C     --贷款整合表
      ON C.RCPT_ID = A.DUEBILLID
     AND C.DATA_DT = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'Y')-1,'YYYYMMDD') --上年末
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO U  --汇率表
      ON U.BASE_CUR = B.CUR
     AND U.CNV_CUR = 'CNY'
     AND U.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO F--对公客户信息
      ON F.CUST_ID = B.CUST_ID
     AND F.DATA_DT = V_P_DATE
    LEFT JOIN TMP_CZBZ TMP1
      ON A.DUEBILLID = TMP1.DUEBILLID
   WHERE A.DATA_DT = V_P_DATE
     AND TRUNC(A.HANDLETIME, 'Y') >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'Y')
     AND B.DATA_SRC IN('对公信贷','票据贴现','票据转贴现') -- 取对公数据
     AND A.ASSETTYPE IN ('不良贷款','不良资产（非信贷）')
       ;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   V_STEP      := V_STEP + 1;
   V_STEP_DESC := '数据插入G12贷款迁徙表-迁徙记录表';
   V_STARTTIME := SYSDATE;

   INSERT INTO A_FGB_G12_MIGRATE
  (
    DATA_SRC	        --01 数据来源
   ,BGRQ	            --02 报告日期
   ,JYWYM	            --03 交易唯一码
   ,WJFLXJLWYM	      --04 五级分类现金流唯一码
   ,NCWJFL	          --05 年初五级分类
   ,NCSFBL	          --06 年初是否不良
   ,BDQWJFL	          --07 变动前五级分类
   ,BDQSFBL		        --08 变动前是否不良
   ,ZCSXJE	          --09 正常收现金额（元）
   ,JKRXJCHJE	        --10 借款人现金偿还金额（元）
   ,DSFXJDCJE	        --11 第三方现金代偿金额（元）
   ,GDDHZRSX	        --12 个贷单户转让收现（元）
   ,GDPLZRSX	        --13 个贷批量转让收现（元）
   ,DGDHZRSX	        --14 对公单户转让收现（元）
   ,DGPLZRSX	        --15 对公批量转让收现（元）
   ,FZRHX	            --16 非转让核销（元）
   ,GDDHZRSSHX	      --17 个贷单户转让损失核销（元）
   ,GDPLZRSSHX	      --18 个贷批量转让损失核销（元）
   ,DGDHZRSSHX	      --19 对公单户转让损失核销（元）
   ,DGPLZRSSHX	      --20 对公批量转让损失核销（元）
   ,YWDZBHZZG	        --21 以物抵债不含债转股（元）
   ,YGDZ	            --22 以股抵债（元）
   ,QTCZ	            --23 其他处置（元）
   ,JSJEHJ	          --24 减少金额合计（元）
   ,ZJJE	            --25 增加金额（元）
   ,BDHWJFL	          --26 变动后五级分类
   ,BDHSFBL	          --27 变动后是否不良
   ,TJYE	            --28 统计余额（元）
   ,QMWJFL	          --29 期末五级分类
   ,QMSFBL	          --30 期末是否不良
   ,CZBS	            --31 重组标识
   ,STHXT	            --32 上调或下调
   ,DKQXFS	          --33 贷款迁徙方式
   ,ZBZHJ	            --34 债变债合计（元）
   ,FCZXTJE	          --35 非重组下调金额（元）
   ,FCZSTJE	          --36 非重组上调金额（元）
   ,BNCZXTJE	        --37 本年重组下调金额（元）
   ,BNCZSTJE	        --38 本年重组上调金额（元）
   ,WNCZXTJE	        --39 往年重组下调金额（元）
   ,WNCZSTJE	        --40 往年重组上调金额（元）
   ,SCFCZSTJE	        --41 首次非重组上调金额（元）
   ,SCFCZSTQWJFL	    --42 首次非重组上调前五级分类
   ,SCBNCZSTJE	      --43 首次本年重组上调金额（元）
   ,SCBNCZSTQWJFL	    --44 首次本年重组上调前五级分类
   ,SCWNCZSTJE	      --45 首次往年重组上调金额（元）
   ,SCWNCZSTQWJFL	    --46 首次往年重组上调前五级分类
   ,ZHWYM	            --47 账户唯一码
   ,KHWYM	            --48 客户唯一码
   ,KHMC	            --49 客户名称
   ,CZSJ              --50 资产保全处置时间
   ,BDSJ              --51 五级分类变动时间
   ,JGBH              --52 机构编号 -- add by liuyu 20230508
  )
    WITH TMP_CZBZ AS ( --取重组标志逻辑
   SELECT /*+ materialize*/
          A.DUEBILLID
         ,MIN(A.HANDLETIME) AS MINTIME
     FROM M_ASSET_PRESERVATION_LEDGET A
    WHERE A.HANDLETYPE IN ('债务重组','借新还旧','展期') --取全部的重组借据
      AND A.DATA_DT = V_P_DATE
    GROUP BY A.DUEBILLID
         /*保全台账：处置方式=债务重组、借新还旧、展期，判断该处置时点之后的所有变动均显示“重组”；
            无出现该类处置方式的，则显示“非重组”*/

  ), TMP_FCZST AS ( --取首次非重组上调
   SELECT /*+ materialize*/
           NVL(A.BAL,0)        AS SCFCZSTJE	        --首次本年非重组上调金额（元）
          ,CASE WHEN A.BF_ADJ_LEVEL5_CLS_CD ='10' THEN '正常类'
                WHEN A.BF_ADJ_LEVEL5_CLS_CD ='20' THEN '关注类'
                WHEN A.BF_ADJ_LEVEL5_CLS_CD ='30' THEN '次级类'
                WHEN A.BF_ADJ_LEVEL5_CLS_CD ='40' THEN '可疑类'
                WHEN A.BF_ADJ_LEVEL5_CLS_CD ='50' THEN '损失类'
           END                 AS SCFCZSTQWJFL	    --首次本年非重组上调前五级分类
          ,ROW_NUMBER()OVER(PARTITION BY A.DUBIL_ID ORDER BY A.ADJ_DT ASC) AS RN
          ,A.FLOW_NUM||A.DUBIL_ID||TO_CHAR(A.ADJ_DT,'YYYYMMDD')          AS SERIALNO          --流水号
     FROM M_CRDT_BUS_CONT_RISK_ADJ_H A
     LEFT JOIN TMP_CZBZ E
       ON A.DUBIL_ID = E.DUEBILLID
    WHERE A.DATA_DT = V_P_DATE
      AND (E.DUEBILLID IS NULL OR A.ADJ_DT < E.MINTIME)
      AND A.BF_ADJ_LEVEL5_CLS_CD IN('30','40','50')
      AND A.A_ADJUST_LEVEL5_CLS_CD IN('10','20') --非重组上调
      AND TRUNC(A.ADJ_DT,'Y') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') --本年调整

  ), TMP_CZST AS ( --取首次重组上调
   SELECT /*+ materialize*/
           NVL(A.BAL,0)       AS SCBNCZSTJE	      --首次本年重组上调金额（元）
          ,CASE WHEN A.BF_ADJ_LEVEL5_CLS_CD ='10' THEN '正常类'
                WHEN A.BF_ADJ_LEVEL5_CLS_CD ='20' THEN '关注类'
                WHEN A.BF_ADJ_LEVEL5_CLS_CD ='30' THEN '次级类'
                WHEN A.BF_ADJ_LEVEL5_CLS_CD ='40' THEN '可疑类'
                WHEN A.BF_ADJ_LEVEL5_CLS_CD ='50' THEN '损失类'
           END                AS SCBNCZSTQWJFL	   --首次本年重组上调前五级分类
          ,ROW_NUMBER()OVER(PARTITION BY A.DUBIL_ID ORDER BY A.ADJ_DT ASC) AS RN
          ,A.FLOW_NUM||A.DUBIL_ID||TO_CHAR(A.ADJ_DT,'YYYYMMDD')         AS SERIALNO          --流水号
     FROM M_CRDT_BUS_CONT_RISK_ADJ_H A
     LEFT JOIN TMP_CZBZ E
       ON A.DUBIL_ID = E.DUEBILLID
    WHERE A.DATA_DT = V_P_DATE
      AND E.DUEBILLID IS NOT NULL AND A.ADJ_DT >= E.MINTIME
      AND A.BF_ADJ_LEVEL5_CLS_CD IN('30','40','50')
      AND A.A_ADJUST_LEVEL5_CLS_CD IN('10','20') --重组上调
      AND TRUNC(A.ADJ_DT,'Y') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')
  )
    SELECT '迁徙记录'||B.DATA_SRC            AS DATA_SRC          --01 数据来源
          ,V_P_DATE                          AS BGRQ              --02 报告日期
          ,A.DUBIL_ID                        AS JYWYM             --03 交易唯一码
          ,A.FLOW_NUM||A.DUBIL_ID||TO_CHAR(A.ADJ_DT,'YYYYMMDD')
                                             AS WJFLXJLWYM        --04 五级分类现金流唯一码
          ,CASE
             WHEN C.LVL5_CL = '01' THEN '正常类'
             WHEN C.LVL5_CL = '02' THEN '关注类'
             WHEN C.LVL5_CL = '03' THEN '次级类'
             WHEN C.LVL5_CL = '04' THEN '可疑类'
             WHEN C.LVL5_CL = '05' THEN '损失类'
             WHEN SUBSTR(B.LOAN_ACT_DSTR_DT,1,4) = SUBSTR(V_P_DATE,1,4) THEN '本年放款不适用'
             ELSE NULL
          END                                AS NCWJFL            --05 年初五级分类
          ,CASE WHEN C.LVL5_CL IN('03','04','05') THEN '是'
                WHEN C.LVL5_CL IN('01','02') THEN '否'
                WHEN SUBSTR(B.LOAN_ACT_DSTR_DT,1,4) = SUBSTR(V_P_DATE,1,4) THEN '本年放款不适用'
                ELSE NULL
           END                               AS NCSFBL            --06 年初是否不良
          ,CASE WHEN A.BF_ADJ_LEVEL5_CLS_CD ='10' THEN '正常类'
                WHEN A.BF_ADJ_LEVEL5_CLS_CD ='20' THEN '关注类'
                WHEN A.BF_ADJ_LEVEL5_CLS_CD ='30' THEN '次级类'
                WHEN A.BF_ADJ_LEVEL5_CLS_CD ='40' THEN '可疑类'
                WHEN A.BF_ADJ_LEVEL5_CLS_CD ='50' THEN '损失类'
           END                               AS BDQWJFL           --07 变动前五级分类
          ,CASE WHEN A.BF_ADJ_LEVEL5_CLS_CD IN ('30','40','50') THEN '是'
                ELSE '否'   END              AS BDQSFBL           --08 变动前是否不良
          ,NULL                              AS ZCSXJE            --09 正常收现金额（元）
          ,NULL                              AS JKRXJCHJE	        --10 借款人现金偿还金额（元）
          ,NULL                              AS DSFXJDCJE	        --11 第三方现金代偿金额（元）
          ,NULL                              AS GDDHZRSX	        --12 个贷单户转让收现（元）
          ,NULL                              AS GDPLZRSX	        --13 个贷批量转让收现（元）
          ,NULL                              AS DGDHZRSX	        --14 对公单户转让收现（元）
          ,NULL                              AS DGPLZRSX	        --15 对公批量转让收现（元）
          ,NULL                              AS FZRHX	            --16 非转让核销（元）
          ,NULL                              AS GDDHZRSSHX	      --17 个贷单户转让损失核销（元）
          ,NULL                              AS GDPLZRSSHX	      --18 个贷批量转让损失核销（元）
          ,NULL                              AS DGDHZRSSHX	      --19 对公单户转让损失核销（元）
          ,NULL                              AS DGPLZRSSHX	      --20 对公批量转让损失核销（元）
          ,NULL                              AS YWDZBHZZG	        --21 以物抵债不含债转股（元）
          ,NULL                              AS YGDZ	            --22 以股抵债（元）
          ,NULL                              AS QTCZ	            --23 其他处置（元）
          ,NULL                              AS JSJEHJ            --24 减少金额合计（元）
          ,NULL                              AS ZJJE              --25 增加金额（元）
          ,CASE WHEN A.A_ADJUST_LEVEL5_CLS_CD ='10'  THEN '正常类'
                WHEN A.A_ADJUST_LEVEL5_CLS_CD ='20'  THEN '关注类'
                WHEN A.A_ADJUST_LEVEL5_CLS_CD ='30'  THEN '次级类'
                WHEN A.A_ADJUST_LEVEL5_CLS_CD ='40'  THEN '可疑类'
                WHEN A.A_ADJUST_LEVEL5_CLS_CD ='50'  THEN '损失类'
          END                                AS BDHWJFL           --26 变动后五级分类
          ,CASE WHEN A.A_ADJUST_LEVEL5_CLS_CD  IN('30','40','50') THEN '是'
                ELSE '否' END                AS BDHSFBL           --27 变动后是否不良
          ,B.LOAN_NET_VAL * U.EXRT           AS TJYE              --28 统计余额（元）
          ,CASE
             WHEN B.LVL5_CL = '01' THEN '正常类'
             WHEN B.LVL5_CL = '02' THEN '关注类'
             WHEN B.LVL5_CL = '03' THEN '次级类'
             WHEN B.LVL5_CL = '04' THEN '可疑类'
             WHEN B.LVL5_CL = '05' THEN '损失类'
             ELSE '不适用'
          END                                AS QMWJFL            --29 期末五级分类
          ,CASE WHEN B.LVL5_CL IN ('03','04','05') THEN '是'
               ELSE '否'  END                AS QMSFBL            --30 期末是否不良
          ,CASE WHEN E.DUEBILLID IS NOT NULL AND A.ADJ_DT >= E.MINTIME THEN '重组'
                ELSE '非重组'  END           AS CZBS              --31 重组标识
          ,CASE WHEN A.BF_ADJ_LEVEL5_CLS_CD  IN('30','40','50') AND A.A_ADJUST_LEVEL5_CLS_CD IN ('10','20') THEN '上调'
                WHEN A.BF_ADJ_LEVEL5_CLS_CD  IN('10','20')  AND A.A_ADJUST_LEVEL5_CLS_CD IN ('30','40','50') THEN '下调'
                ELSE '不适用'
           END                               AS STHXT             --32 上调或下调
          ,CASE WHEN E.DUEBILLID IS NOT NULL AND A.ADJ_DT >= E.MINTIME  THEN
                     CASE WHEN A.BF_ADJ_LEVEL5_CLS_CD IN('30','40','50') AND A.A_ADJUST_LEVEL5_CLS_CD IN ('10','20') THEN '重组上调'
                          WHEN A.BF_ADJ_LEVEL5_CLS_CD IN('10','20') AND A.A_ADJUST_LEVEL5_CLS_CD IN ('30','40','50') THEN '重组下调'
                          ELSE '重组不适用'
                     END
                WHEN (E.DUEBILLID IS NULL OR A.ADJ_DT < E.MINTIME) THEN
                     CASE WHEN A.BF_ADJ_LEVEL5_CLS_CD IN('30','40','50') AND A.A_ADJUST_LEVEL5_CLS_CD IN ('10','20') THEN '非重组上调'
                          WHEN A.BF_ADJ_LEVEL5_CLS_CD IN('10','20')  AND A.A_ADJUST_LEVEL5_CLS_CD IN ('30','40','50') THEN '非重组下调'
                          ELSE '非重组不适用'
                     END
                ELSE '不适用'
           END                               AS DKQXFS            --33 贷款迁徙方式
          ,''                                AS ZBZHJ             --34 债变债合计（元）
          ,CASE WHEN (E.DUEBILLID IS NULL OR A.ADJ_DT < E.MINTIME)
                AND A.BF_ADJ_LEVEL5_CLS_CD IN('10','20')
                AND A.A_ADJUST_LEVEL5_CLS_CD IN ('30','40','50')
                AND TRUNC(A.ADJ_DT,'Y') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') THEN NVL(A.BAL,0)
                ELSE 0      END              AS FCZXTJE           --35 非重组下调金额（元）
          ,CASE WHEN (E.DUEBILLID IS NULL OR A.ADJ_DT < E.MINTIME)
                AND A.BF_ADJ_LEVEL5_CLS_CD IN('30','40','50')
                AND A.A_ADJUST_LEVEL5_CLS_CD IN('10','20')
                AND TRUNC(A.ADJ_DT,'Y') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') THEN NVL(A.BAL,0)
                ELSE 0   END                 AS FCZSTJE           --36 非重组上调金额（元）
          ,CASE WHEN E.DUEBILLID IS NOT NULL AND A.ADJ_DT >= E.MINTIME
                AND A.BF_ADJ_LEVEL5_CLS_CD IN('10','20')
                AND A.A_ADJUST_LEVEL5_CLS_CD IN ('30','40','50')
                AND TRUNC(A.ADJ_DT,'Y') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') THEN NVL(A.BAL,0)
                ELSE 0      END              AS BNCZXTJE          --37 本年重组下调金额（元）
          ,CASE WHEN E.DUEBILLID IS NOT NULL AND A.ADJ_DT >= E.MINTIME
                AND A.BF_ADJ_LEVEL5_CLS_CD IN('30','40','50')
                AND A.A_ADJUST_LEVEL5_CLS_CD IN('10','20')
                AND TRUNC(A.ADJ_DT,'Y') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') THEN NVL(A.BAL,0)
                ELSE 0   END                 AS BNCZSTJE          --38 本年重组上调金额（元）
          ,NULL                              AS WNCZXTJE          --39 往年重组下调金额（元）
          ,NULL                              AS WNCZSTJE          --40 往年重组上调金额（元）
          ,T1.SCFCZSTJE                      AS SCFCZSTJE	        --41 首次非重组上调金额（元）
          ,T1.SCFCZSTQWJFL                   AS SCFCZSTQWJFL	    --42 首次非重组上调前五级分类
          ,T2.SCBNCZSTJE                     AS SCBNCZSTJE	      --43 首次本年重组上调金额（元）
          ,T2.SCBNCZSTQWJFL                  AS SCBNCZSTQWJFL	    --44 首次本年重组上调前五级分类
          ,NULL                              AS SCWNCZSTJE	      --45 首次往年重组上调金额（元）
          ,NULL                              AS SCWNCZSTQWJFL	    --46 首次往年重组上调前五级分类
          ,A.BUS_CONT_ID                     AS ZHWYM             --47 账户唯一码
          ,A.CUST_ID                         AS KHWYM             --48 客户唯一码
          ,A.CUST_NAME                       AS KHMC              --49 客户名称
          ,TO_CHAR(E.MINTIME,'YYYYMMDD')     AS CZSJ              --50 资产保全处置时间
          ,TO_CHAR(A.ADJ_DT,'YYYYMMDD')      AS BDSJ              --51 五级分类变动时间
          ,B.ORG_ID                          AS JGBH              --52 机构编号
      FROM M_CRDT_BUS_CONT_RISK_ADJ_H  A   --信贷业务合同风险调整历史
      LEFT JOIN S_LOAN B --贷款整合表 当前时点
        ON B.RCPT_ID = A.DUBIL_ID
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN S_LOAN C --贷款整合表 上年末就是年初
        ON C.RCPT_ID = A.DUBIL_ID
       AND C.DATA_DT = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1,'YYYYMMDD')
      LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO U  --汇率表
        ON U.BASE_CUR = B.CUR
       AND U.CNV_CUR = 'CNY'
       AND U.DATA_DT = V_P_DATE
      LEFT JOIN TMP_CZBZ E --重组标志
        ON E.DUEBILLID = A.DUBIL_ID
      LEFT JOIN TMP_FCZST T1 --首次非重组上调
        ON T1.SERIALNO = A.FLOW_NUM||A.DUBIL_ID||TO_CHAR(A.ADJ_DT,'YYYYMMDD')
       AND T1.RN = 1
      LEFT JOIN TMP_CZST T2  --首次非重组上调
        ON T2.SERIALNO = A.FLOW_NUM||A.DUBIL_ID||TO_CHAR(A.ADJ_DT,'YYYYMMDD')
       AND T2.RN = 1
     WHERE A.DATA_DT =V_P_DATE
       AND (B.LOAN_NET_VAL <> 0 OR C.LOAN_NET_VAL <> 0 OR SUBSTR(B.LOAN_ACT_DSTR_DT,1,4) = SUBSTR(V_P_DATE,1,4))
        ;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,WJFLXJLWYM,DATA_SRC,COUNT(1)
      FROM RRP_MDL.A_FGB_G12_MIGRATE T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,WJFLXJLWYM,DATA_SRC
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
     V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_A_FGB_G12_MIGRATE;
/

