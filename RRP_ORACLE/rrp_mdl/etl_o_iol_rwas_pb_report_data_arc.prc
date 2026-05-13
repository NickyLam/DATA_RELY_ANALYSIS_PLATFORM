CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_RWAS_PB_REPORT_DATA_ARC(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_RWAS_PB_REPORT_DATA_ARC
  *  功能描述：公共报表数据表-归档数据
  *  创建日期：20240312
  *  开发人员：YUJINGYI
  *  来源表：
  *  目标表： O_IOL_RWAS_PB_REPORT_DATA_ARC
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240312  YUJINGYI     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_RWAS_PB_REPORT_DATA_ARC'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_RPT_DATE  VARCHAR2(8);
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_RWAS_PB_REPORT_DATA_ARC T WHERE T.DATA_DATE = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_RWAS_PB_REPORT_DATA_ARC';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


-- 如果满足启动时间，此时CONTROL-M调用的数据日期是T+1，因此我们需要根据调用的数据日期获取相关的真正取数日期（即数据日期）
/*    IF TO_CHAR(TO_DATE(I_P_DATE, 'YYYYMMDD')+1, 'DD') = '01' THEN
      V_RPT_DATE := I_P_DATE;
    ELSE
      V_RPT_DATE := TO_NUMBER(TO_CHAR(TO_DATE(SUBSTR(I_P_DATE, 1, 6)||'01', 'YYYYMMDD')-1, 'YYYYMMDD'));
    END IF;*/

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-公共报表数据表-归档数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_RWAS_PB_REPORT_DATA_ARC
  (
    DATA_ID              --主键ID                                             
   ,ITEM_CD              --报表编码                                           
   ,ITEM_NAME            --报表名称                                           
   ,LINE_NUMBER          --行号                                               
   ,ITEM_A               --A列                                                
   ,ITEM_B               --B列                                                
   ,ITEM_C               --C列                                                
   ,ITEM_D               --D列                                                
   ,ITEM_E               --E列                                                
   ,ITEM_F               --F列                                                
   ,ITEM_G               --G列                                                
   ,ITEM_H               --H列                                                
   ,ITEM_I               --I列                                                
   ,ITEM_J               --J列                                                
   ,ITEM_K               --K列                                                
   ,ITEM_L               --L列                                                
   ,ITEM_M               --M列                                                
   ,ITEM_N               --N列                                                
   ,ITEM_O               --O列                                                
   ,ITEM_P               --P列                                                
   ,ITEM_Q               --Q列                                                
   ,ITEM_R               --R列                                                
   ,ITEM_S               --S列                                                
   ,ITEM_T               --T列                                                
   ,ITEM_U               --U列                                                
   ,ITEM_V               --V列                                                
   ,ITEM_W               --W列                                                
   ,ITEM_X               --X列                                                
   ,ITEM_Y               --Y列                                                
   ,ITEM_Z               --Z列                                                
   ,ITEM_AA              --AA列                                               
   ,ITEM_AB              --AB列                                               
   ,ITEM_AC              --AC列                                               
   ,ITEM_AD              --AD列                                               
   ,ITEM_AE              --AE列                                               
   ,ITEM_AF              --AF列                                               
   ,LOAD_DATE            --加载时间                                           
   ,DATA_DATE            --数据日期(格式YYYYMMDD)                             
   ,SOLO_NO              --法人机构编号                                       
   ,ITEM_AG              --AG列                                               
   ,ITEM_AH              --AH列                                               
   ,ITEM_AI              --AI列                                               
   ,ITEM_AJ              --AJ列                                               
   ,ITEM_AK              --AK列                                               
   ,ITEM_AL              --AL列                                               
   ,ITEM_AM              --AM列                                               
   ,ITEM_AN              --AN列                                               
   ,ITEM_AO              --AO列                                               
   ,ITEM_AP              --AP列                                               
   ,ITEM_AQ              --AQ列                                               
   ,ITEM_AR              --AR列                                               
   ,ITEM_AS              --AS列                                               
   ,ITEM_AT              --AT列                                               
   ,ITEM_AU              --AU列                                               
   ,ITEM_AV              --AV列                                               
   ,ITEM_AW              --AW列                                               
   ,ITEM_AX              --AX列                                               
   ,ITEM_AY              --AY列                                               
   ,ITEM_AZ              --AZ列                                               
   ,ITEM_BA              --BA列                                               
   ,ITEM_BB              --BB列                                               
   ,ITEM_BC              --BC列                                               
   ,ITEM_BD              --BD列                                               
   ,ITEM_BE              --BE列                                               
   ,ITEM_BF              --BF列                                               
   ,ITEM_BG              --BG列                                               
   ,ITEM_BH              --BH列                                               
   ,ITEM_BI              --BI列                                               
   ,ITEM_BJ              --BJ列                                               
   ,ITEM_BK              --BK列                                               
   ,ITEM_BL              --BL列                                               
   ,ITEM_BM              --BM列                                               
   ,ITEM_BN              --BN列                                               
   ,ITEM_BO              --BO列                                               
   ,ITEM_BP              --BP列                                               
   ,ITEM_BQ              --BQ列                                               
   ,ITEM_BR              --BR列                                               
   ,ITEM_BS              --BS列                                               
   ,ITEM_BT              --BT列                                               
   ,ITEM_BU              --BU列                                               
   ,ITEM_BV              --BV列                                               
   ,ITEM_BW              --BW列                                               
   ,ITEM_BX              --BX列                                               
   ,ITEM_BY              --BY列                                               
   ,ITEM_BZ              --BZ列                                               
   ,ITEM_CA              --CA列                                               
   ,ITEM_CB              --CB列                                               
   ,ITEM_CC              --CC列                                               
   ,ITEM_CCD             --CD列                                               
   ,ITEM_CE              --CE列                                               
   ,ITEM_CF              --CF列                                               
   ,ITEM_CG              --CG列                                               
   ,ITEM_CH              --CH列                                               
   ,ITEM_CI              --CI列                                               
   ,ITEM_CJ              --CJ列                                               
   ,ITEM_CK              --CK列                                               
   ,ITEM_CL              --CL列                                               
   ,ITEM_CM              --CM列                                               
   ,ITEM_CN              --CN列                                               
   ,ITEM_CO              --CO列                                               
   ,ITEM_CP              --CP列                                               
   ,ITEM_CQ              --CQ列                                               
   ,ITEM_CR              --CR列                                               
   ,ITEM_CS              --CS列                                               
   ,ITEM_CT              --CT列                                               
   ,ITEM_CU              --CU列                                               
   ,ITEM_CV              --CV列                                               
   ,ITEM_CW              --CW列                                               
   ,ITEM_CX              --CX列                                               
   ,ITEM_CY              --CY列                                               
   ,ITEM_CZ              --CZ列                                               
   ,ORG_CD               --机构编号                                           
   ,CCY_CD               --币种编号                                           
   ,VERSION              --版本                                               
   ,VERSION_STATUS       --版本状态，1-保存，2-审批中，3-正式版本， 4-历史版本
   ,OPERATE_DT           --操作时间                                           
   ,OPERATE_ID           --操作人ID                                           
   ,OPERATE_NAME         --操作人姓名                                         
   ,FLOW_STARTER_ID      --流程发起人ID                                       
   ,FLOW_STARTER_NAME    --流程发起人姓名                                     
   ,START_DT             --开始时间                                           
   ,END_DT               --结束时间                                           
   ,ID_MARK              --增删标志                                           
   ,ETL_TIMESTAMP        --ETL处理时间戳                                      
    )
    SELECT
        DATA_ID              --主键ID                                             
       ,ITEM_CD              --报表编码                                           
       ,ITEM_NAME            --报表名称                                           
       ,LINE_NUMBER          --行号                                               
       ,ITEM_A               --A列                                                
       ,ITEM_B               --B列                                                
       ,ITEM_C               --C列                                                
       ,ITEM_D               --D列                                                
       ,ITEM_E               --E列                                                
       ,ITEM_F               --F列                                                
       ,ITEM_G               --G列                                                
       ,ITEM_H               --H列                                                
       ,ITEM_I               --I列                                                
       ,ITEM_J               --J列                                                
       ,ITEM_K               --K列                                                
       ,ITEM_L               --L列                                                
       ,ITEM_M               --M列                                                
       ,ITEM_N               --N列                                                
       ,ITEM_O               --O列                                                
       ,ITEM_P               --P列                                                
       ,ITEM_Q               --Q列                                                
       ,ITEM_R               --R列                                                
       ,ITEM_S               --S列                                                
       ,ITEM_T               --T列                                                
       ,ITEM_U               --U列                                                
       ,ITEM_V               --V列                                                
       ,ITEM_W               --W列                                                
       ,ITEM_X               --X列                                                
       ,ITEM_Y               --Y列                                                
       ,ITEM_Z               --Z列                                                
       ,ITEM_AA              --AA列                                               
       ,ITEM_AB              --AB列                                               
       ,ITEM_AC              --AC列                                               
       ,ITEM_AD              --AD列                                               
       ,ITEM_AE              --AE列                                               
       ,ITEM_AF              --AF列                                               
       ,LOAD_DATE            --加载时间                                           
       ,DATA_DATE            --数据日期(格式YYYYMMDD)                             
       ,'000000'--SOLO_NO              --法人机构编号                                       
       ,ITEM_AG              --AG列                                               
       ,ITEM_AH              --AH列                                               
       ,ITEM_AI              --AI列                                               
       ,ITEM_AJ              --AJ列                                               
       ,ITEM_AK              --AK列                                               
       ,ITEM_AL              --AL列                                               
       ,ITEM_AM              --AM列                                               
       ,ITEM_AN              --AN列                                               
       ,ITEM_AO              --AO列                                               
       ,ITEM_AP              --AP列                                               
       ,ITEM_AQ              --AQ列                                               
       ,ITEM_AR              --AR列                                               
       ,ITEM_AS              --AS列                                               
       ,ITEM_AT              --AT列                                               
       ,ITEM_AU              --AU列                                               
       ,ITEM_AV              --AV列                                               
       ,ITEM_AW              --AW列                                               
       ,ITEM_AX              --AX列                                               
       ,ITEM_AY              --AY列                                               
       ,ITEM_AZ              --AZ列                                               
       ,ITEM_BA              --BA列                                               
       ,ITEM_BB              --BB列                                               
       ,ITEM_BC              --BC列                                               
       ,ITEM_BD              --BD列                                               
       ,ITEM_BE              --BE列                                               
       ,ITEM_BF              --BF列                                               
       ,ITEM_BG              --BG列                                               
       ,ITEM_BH              --BH列                                               
       ,ITEM_BI              --BI列                                               
       ,ITEM_BJ              --BJ列                                               
       ,ITEM_BK              --BK列                                               
       ,ITEM_BL              --BL列                                               
       ,ITEM_BM              --BM列                                               
       ,ITEM_BN              --BN列                                               
       ,ITEM_BO              --BO列                                               
       ,ITEM_BP              --BP列                                               
       ,ITEM_BQ              --BQ列                                               
       ,ITEM_BR              --BR列                                               
       ,ITEM_BS              --BS列                                               
       ,ITEM_BT              --BT列                                               
       ,ITEM_BU              --BU列                                               
       ,ITEM_BV              --BV列                                               
       ,ITEM_BW              --BW列                                               
       ,ITEM_BX              --BX列                                               
       ,ITEM_BY              --BY列                                               
       ,ITEM_BZ              --BZ列                                               
       ,ITEM_CA              --CA列                                               
       ,ITEM_CB              --CB列                                               
       ,ITEM_CC              --CC列                                               
       ,ITEM_CCD             --CD列                                               
       ,ITEM_CE              --CE列                                               
       ,ITEM_CF              --CF列                                               
       ,ITEM_CG              --CG列                                               
       ,ITEM_CH              --CH列                                               
       ,ITEM_CI              --CI列                                               
       ,ITEM_CJ              --CJ列                                               
       ,ITEM_CK              --CK列                                               
       ,ITEM_CL              --CL列                                               
       ,ITEM_CM              --CM列                                               
       ,ITEM_CN              --CN列                                               
       ,ITEM_CO              --CO列                                               
       ,ITEM_CP              --CP列                                               
       ,ITEM_CQ              --CQ列                                               
       ,ITEM_CR              --CR列                                               
       ,ITEM_CS              --CS列                                               
       ,ITEM_CT              --CT列                                               
       ,ITEM_CU              --CU列                                               
       ,ITEM_CV              --CV列                                               
       ,ITEM_CW              --CW列                                               
       ,ITEM_CX              --CX列                                               
       ,ITEM_CY              --CY列                                               
       ,ITEM_CZ              --CZ列                                               
       ,'000000'--ORG_CD               --机构编号                                           
       ,CCY_CD               --币种编号                                           
       ,VERSION              --版本                                               
       ,VERSION_STATUS       --版本状态，1-保存，2-审批中，3-正式版本， 4-历史版本
       ,OPERATE_DT           --操作时间                                           
       ,OPERATE_ID           --操作人ID                                           
       ,OPERATE_NAME         --操作人姓名                                         
       ,FLOW_STARTER_ID      --流程发起人ID                                       
       ,FLOW_STARTER_NAME    --流程发起人姓名                                     
       ,START_DT             --开始时间                                           
       ,END_DT               --结束时间                                           
       ,ID_MARK              --增删标志                                           
       ,ETL_TIMESTAMP        --ETL处理时间戳
    FROM IOL.V_RWAS_PB_REPORT_DATA_ARC --视图-公共报表数据表-归档数据
    WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    AND ITEM_C <> 'A'
    AND ID_MARK <> 'D'
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

  END ETL_O_IOL_RWAS_PB_REPORT_DATA_ARC;
/

