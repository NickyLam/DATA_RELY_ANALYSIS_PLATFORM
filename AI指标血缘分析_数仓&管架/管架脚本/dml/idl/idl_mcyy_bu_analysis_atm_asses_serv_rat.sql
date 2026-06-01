/*
Purpose:    ATM考核率服务率统计分析-业务分析表:自助设备 
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_bu_analysis_atm_asses_serv_rat
Createdate: 20210428

-- 以下为依赖了上游的表 :
                            itl_edw_atms_rpt_open_rate_dev_date 
              msl_atms_dev_base_info      
              msl_atms_dev_catalog_table  
              msl_atms_dev_type_table     
Logs:
            
1.20260302 修改 date_time 逻辑日期 修改 

*/
 
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;


alter table ${idl_schema}.mcyy_bu_analysis truncate subpartition p_${batch_date}_atm_asses_serv_rat;


-- 1.2 add today partition
whenever sqlerror continue none;
alter table ${idl_schema}.mcyy_bu_analysis add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_atm_asses_serv_rat values ('ATM_ASSES_SERV_RAT')
                                              )
;
alter table ${idl_schema}.mcyy_bu_analysis modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_atm_asses_serv_rat values ('ATM_ASSES_SERV_RAT')
;


-- 2.1 基础指标数据处理

--2.1.1 第一组 开机率

--2.1.1.1 先将设备数据插入到表
whenever sqlerror exit sql.sqlcode;
INSERT INTO ${idl_schema}.mcyy_bu_analysis
    (etl_dt -- 数据日期
    ,etl_timestamp -- ETL处理时间戳
    ,index_no -- 指标编码
    ,index_name -- 指标名称
    ,org_no -- 机构编码
    ,org_name -- 机构名称
    ,super_org_no -- 上级机构编码
    ,accu_index_value_d -- 当日累计
    ,accu_index_value_m -- 当月累计
    ,accu_index_value_q -- 当季累计
    ,accu_index_value_y -- 当年累计
    ,unit -- 单位
    ,frequency -- 频度
    ,measure_no --- 度量编号
    ,index_measure -- 度量名称
    ,source_sys --来源系统
     )
    WITH tmp_atm_asses_serv_rat_data_d AS
     (SELECT (CASE
                 WHEN 分母 = 0 THEN
                  1
                 ELSE
                  (全功能 + 故障停机 + 离线停机 - 流水打印机缺纸停机 + 出钞门故障 + 机芯故障 + 维护停机) / 分母
             END) 开机率
            ,(CASE
                 WHEN 分母 = 0 THEN
                  1
                 ELSE
                  全功能 / 分母
             END) 服务率
            ,org_no
            ,super_org_no
      FROM   (SELECT rdor.full_fun_time AS 全功能
                    ,(rdor.hard_fault_time + rdor.soft_fault_time +
                     rdor.other_reason_time) AS 故障停机
                    ,(rdor.vcomm_failure_time + rdor.close_time +
                     rdor.comm_failure_time) AS 离线停机
                     ,SHORT_PAPER_TIME as 流水打印机缺纸停机
                     ,CASH_GATE_TIME as 出钞门故障
                     ,MOVEMENT_FAIL_TIME as 机芯故障
                     ,maintenance_time as 维护停机
                    ,(rdor.work_time - rdor.stop_time) AS 分母
                    ,rdor.dev_no AS org_no
                    ,(CASE
                         WHEN substr(dbi.org_no
                                    ,1
                                    ,2) = '89'
                              OR dbi.org_no = '800001' THEN
                          '000000'
                         ELSE
                          dbi.org_no
                     END) AS super_org_no
              FROM   itl_edw_atms_rpt_open_rate_dev_date rdor
                    ,msl_atms_dev_base_info      dbi
                    ,msl_atms_dev_catalog_table  dct
                    ,msl_atms_dev_type_table     dtt
              WHERE  to_date(replace(replace(rdor.date_time,'20250229','20991231'),'20260229','20991231'),'yyyy-mm-dd') =
                     to_date('${batch_date}'
                            ,'yyyymmdd')
              -- WHERE  rdor.date_time = '${batch_date}'  -- 20260302 修改 
              AND    dbi.dev_catalog = dct.no
              AND    dbi.dev_type = dtt.no
              AND    rdor.dev_no = dbi.no
              AND    dbi.status <> '0' --不含注销设备
              AND    dbi.dev_catalog <> '10007' --排除回单机
              AND    dct.name in ('ATM','CRS')
              ) t
      
      ),
    tmp_atm_asses_serv_rat_data_m AS
     (SELECT (CASE
                 WHEN 分母 = 0 THEN
                  1
                 ELSE
                  (全功能 + 故障停机 + 离线停机 - 流水打印机缺纸停机 + 出钞门故障 + 机芯故障 + 维护停机) / 分母
             END) 开机率
            ,(CASE
                 WHEN 分母 = 0 THEN
                  1
                 ELSE
                  全功能 / 分母
             END) 服务率
            ,org_no
            ,super_org_no
      FROM   (SELECT SUM(rdor.full_fun_time) AS 全功能
                    ,SUM(rdor.hard_fault_time + rdor.soft_fault_time +
                         rdor.other_reason_time) AS 故障停机
                    ,SUM(rdor.vcomm_failure_time + rdor.close_time +
                         rdor.comm_failure_time) AS 离线停机
                      ,SUM(SHORT_PAPER_TIME) as 流水打印机缺纸停机
                     ,SUM(CASH_GATE_TIME) as 出钞门故障
                     ,SUM(MOVEMENT_FAIL_TIME) as 机芯故障
                     ,SUM(maintenance_time) as 维护停机
                    ,SUM(rdor.work_time - rdor.stop_time) AS 分母
                    ,rdor.dev_no AS org_no
                    ,(CASE
                         WHEN substr(dbi.org_no
                                    ,1
                                    ,2) = '89'
                              OR dbi.org_no = '800001' THEN
                          '000000'
                         ELSE
                          dbi.org_no
                     END) AS super_org_no
              FROM   itl_edw_atms_rpt_open_rate_dev_date rdor
                    ,msl_atms_dev_base_info      dbi
                    ,msl_atms_dev_catalog_table  dct
                    ,msl_atms_dev_type_table     dtt
              WHERE  to_date(replace(replace(rdor.date_time,'20250229','20991231'),'20260229','20991231'),'yyyy-mm-dd') >=
                     trunc(to_date('${batch_date}'
                                  ,'yyyyMMdd')
                          ,'MM')
              AND    to_date(replace(replace(rdor.date_time,'20250229','20991231'),'20260229','20991231'),'yyyy-mm-dd') <=
                     to_date('${batch_date}'
                             ,'yyyyMMdd')
              AND    dbi.dev_catalog = dct.no
              AND    dbi.dev_type = dtt.no
              AND    rdor.dev_no = dbi.no
              AND    dbi.status <> '0' --不含注销设备
              AND    dbi.dev_catalog <> '10007' --排除回单机
              AND    dct.name in ('ATM','CRS')

              GROUP  BY rdor.dev_no
                       ,(CASE
                            WHEN substr(dbi.org_no
                                       ,1
                                       ,2) = '89'
                                 OR dbi.org_no = '800001' THEN
                             '000000'
                            ELSE
                             dbi.org_no
                        END)) t
      
      ),
    
    tmp_atm_asses_serv_rat_data_q AS
     (SELECT (CASE
                 WHEN 分母 = 0 THEN
                  1
                 ELSE
                  (全功能 + 故障停机 + 离线停机 - 流水打印机缺纸停机 + 出钞门故障 + 机芯故障 + 维护停机) / 分母
             END) 开机率
            ,(CASE
                 WHEN 分母 = 0 THEN
                  1
                 ELSE
                  全功能 / 分母
             END) 服务率
            ,org_no
            ,super_org_no
      FROM   (SELECT SUM(rdor.full_fun_time) AS 全功能
                    ,SUM(rdor.hard_fault_time + rdor.soft_fault_time +
                         rdor.other_reason_time) AS 故障停机
                    ,SUM(rdor.vcomm_failure_time + rdor.close_time +
                         rdor.comm_failure_time) AS 离线停机
                          ,SUM(SHORT_PAPER_TIME) as 流水打印机缺纸停机
                     ,SUM(CASH_GATE_TIME) as 出钞门故障
                     ,SUM(MOVEMENT_FAIL_TIME) as 机芯故障
                     ,SUM(maintenance_time) as 维护停机
                    ,SUM(rdor.work_time - rdor.stop_time) AS 分母
                    ,rdor.dev_no AS org_no
                    ,(CASE
                         WHEN substr(dbi.org_no
                                    ,1
                                    ,2) = '89'
                              OR dbi.org_no = '800001' THEN
                          '000000'
                         ELSE
                          dbi.org_no
                     END) AS super_org_no
              FROM   itl_edw_atms_rpt_open_rate_dev_date rdor
                    ,msl_atms_dev_base_info      dbi
                    ,msl_atms_dev_catalog_table  dct
                    ,msl_atms_dev_type_table     dtt
              WHERE  to_date(replace(replace(rdor.date_time,'20250229','20991231'),'20260229','20991231'),'yyyy-mm-dd') >=
                     trunc(to_date('${batch_date}'
                                  ,'yyyymmdd')
                          ,'Q')
              AND    to_date(replace(replace(rdor.date_time,'20250229','20991231'),'20260229','20991231'),'yyyy-mm-dd') <=
                     to_date('${batch_date}'
                             ,'yyyyMMdd')
              AND    dbi.dev_catalog = dct.no
              AND    dbi.dev_type = dtt.no
              AND    rdor.dev_no = dbi.no
              AND    dbi.status <> '0' --不含注销设备
              AND    dbi.dev_catalog <> '10007' --排除回单机
              AND    dct.name in ('ATM','CRS')

              GROUP  BY rdor.dev_no
                       ,(CASE
                            WHEN substr(dbi.org_no
                                       ,1
                                       ,2) = '89'
                                 OR dbi.org_no = '800001' THEN
                             '000000'
                            ELSE
                             dbi.org_no
                        END)) t
      
      ),
    tmp_atm_asses_serv_rat_data_y AS
     (SELECT (CASE
                 WHEN 分母 = 0 THEN
                  1
                 ELSE
                  (全功能 + 故障停机 + 离线停机 - 流水打印机缺纸停机 + 出钞门故障 + 机芯故障 + 维护停机) / 分母
             END) 开机率
            ,(CASE
                 WHEN 分母 = 0 THEN
                  1
                 ELSE
                  全功能 / 分母
             END) 服务率
            ,org_no
            ,super_org_no
      FROM   (SELECT SUM(rdor.full_fun_time) AS 全功能
                    ,SUM(rdor.hard_fault_time + rdor.soft_fault_time +
                         rdor.other_reason_time) AS 故障停机
                    ,SUM(rdor.vcomm_failure_time + rdor.close_time +
                         rdor.comm_failure_time) AS 离线停机
                          ,SUM(SHORT_PAPER_TIME) as 流水打印机缺纸停机
                     ,SUM(CASH_GATE_TIME) as 出钞门故障
                     ,SUM(MOVEMENT_FAIL_TIME) as 机芯故障
                     ,SUM(maintenance_time) as 维护停机
                    ,SUM(rdor.work_time - rdor.stop_time) AS 分母
                    ,rdor.dev_no AS org_no
                    ,(CASE
                         WHEN substr(dbi.org_no
                                    ,1
                                    ,2) = '89'
                              OR dbi.org_no = '800001' THEN
                          '000000'
                         ELSE
                          dbi.org_no
                     END) AS super_org_no
              FROM   itl_edw_atms_rpt_open_rate_dev_date rdor
                    ,msl_atms_dev_base_info      dbi
                    ,msl_atms_dev_catalog_table  dct
                    ,msl_atms_dev_type_table     dtt
              WHERE  to_date(replace(replace(rdor.date_time,'20250229','20991231'),'20260229','20991231'),'yyyy-mm-dd') >=
                     trunc(to_date('${batch_date}'
                                  ,'yyyyMMdd')
                          ,'yyyy')
              AND    to_date(replace(replace(rdor.date_time,'20250229','20991231'),'20260229','20991231'),'yyyy-mm-dd') <=
                     to_date('${batch_date}'
                             ,'yyyyMMdd')
              AND    dbi.dev_catalog = dct.no
              AND    dbi.dev_type = dtt.no
              AND    rdor.dev_no = dbi.no
              AND    dbi.status <> '0' --不含注销设备
              AND    dbi.dev_catalog <> '10007' --排除回单机
              AND    dct.name in ('ATM','CRS')

              GROUP  BY rdor.dev_no
                       ,(CASE
                            WHEN substr(dbi.org_no
                                       ,1
                                       ,2) = '89'
                                 OR dbi.org_no = '800001' THEN
                             '000000'
                            ELSE
                             dbi.org_no
                        END)) t
      
      ),
    tmp_td_initza AS
    --当日数据初始化
     (SELECT t6.index_no
            , --指标编码
             t6.index_name_mcs AS index_name
            , --指标名称
             t2.org_no         AS org_no --柜员号
            ,t2.org_no         AS org_name
            , --存在柜员名称为空的情况，所以统一用柜员号标识
             t2.super_org_no   AS super_org_no
            , --柜员所属支行机构编码
             t2.开机率         AS accu_index_value_d --当日累计
            ,coalesce(t3.开机率
                     ,0) AS accu_index_value_m --当月累计
            ,coalesce(t4.开机率
                     ,0) AS accu_index_value_q --当季累计 
            ,coalesce(t5.开机率
                     ,0) AS accu_index_value_y --当年累计
            ,t6.unit
            , -- 单位
             t6.frequency
            , -- 频度
             NULL             measure_no
            , --- 度量编号
             t6.index_measure -- 度量名称
      FROM   ${idl_schema}.mcyy_orga_para t1
      LEFT   JOIN tmp_atm_asses_serv_rat_data_d t2 --当日
      ON     t1.org_no = t2.super_org_no
      LEFT   JOIN tmp_atm_asses_serv_rat_data_m t3 --当月
      ON     t2.org_no = t3.org_no
      AND    t2.super_org_no = t3.super_org_no
      LEFT   JOIN tmp_atm_asses_serv_rat_data_q t4 --当季
      ON     t2.org_no = t4.org_no
      AND    t2.super_org_no = t4.super_org_no
      LEFT   JOIN tmp_atm_asses_serv_rat_data_y t5 --当年
      ON     t2.org_no = t5.org_no
      AND    t2.super_org_no = t5.super_org_no
      INNER  JOIN ${idl_schema}.mcyy_index_define t6
      ON     'WD041003' = t6.index_no_mcs
      WHERE  length(t1.super_org_no) = 3 --只关联支行
      AND  T2.super_org_no IS NOT NULL
      )
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') etl_dt -- 数据日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
          ,mcyy_bu_analysis_tmp.index_no -- 指标编码
          ,mcyy_bu_analysis_tmp.index_name -- 指标名称
          ,mcyy_bu_analysis_tmp.org_no -- 机构编码
          ,mcyy_bu_analysis_tmp.org_name -- 机构名称
          ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_d) -- 当日累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_q) -- 当季累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_y) -- 当年累计          
          ,mcyy_bu_analysis_tmp.unit -- 单位
          ,mcyy_bu_analysis_tmp.frequency -- 频度
          ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
          ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
          ,'ATM_ASSES_SERV_RAT' source_sys --来源系统
    FROM   (SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,accu_index_value_d
                  ,               accu_index_value_m
                  ,               accu_index_value_q
                  ,               accu_index_value_y
                  ,unit
                  ,frequency
                  ,measure_no
                  ,index_measure
            FROM   tmp_td_initza
            
           
            
            ) mcyy_bu_analysis_tmp
    
    GROUP  BY mcyy_bu_analysis_tmp.index_no -- 指标编码
             ,mcyy_bu_analysis_tmp.index_name -- 指标名称
             ,mcyy_bu_analysis_tmp.org_no -- 机构编码
             ,mcyy_bu_analysis_tmp.org_name -- 机构名称
             ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
             ,mcyy_bu_analysis_tmp.unit -- 单位
             ,mcyy_bu_analysis_tmp.frequency -- 频度
             ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
             ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
    
    ;

COMMIT;

--2.1.1 第二组 服务率

--2.1.1.1 先将设备数据插入到表
whenever sqlerror EXIT sql.sqlcode;
INSERT INTO ${idl_schema}.mcyy_bu_analysis
    (etl_dt -- 数据日期
    ,etl_timestamp -- ETL处理时间戳
    ,index_no -- 指标编码
    ,index_name -- 指标名称
    ,org_no -- 机构编码
    ,org_name -- 机构名称
    ,super_org_no -- 上级机构编码
    ,accu_index_value_d -- 当日累计
    ,accu_index_value_m -- 当月累计
    ,accu_index_value_q -- 当季累计
    ,accu_index_value_y -- 当年累计
    ,unit -- 单位
    ,frequency -- 频度
    ,measure_no --- 度量编号
    ,index_measure -- 度量名称
    ,source_sys --来源系统
     )
    WITH tmp_atm_asses_serv_rat_data_d AS
     (SELECT (CASE
                 WHEN 分母 = 0 THEN
                  1
                 ELSE
                  (全功能 + 故障停机 + 离线停机) / 分母
             END) 开机率
            ,(CASE
                 WHEN 分母 = 0 THEN
                  1
                 ELSE
                  全功能 / 分母
             END) 服务率
            ,org_no
            ,super_org_no
      FROM   (SELECT rdor.full_fun_time AS 全功能
                    ,(rdor.hard_fault_time + rdor.soft_fault_time +
                     rdor.other_reason_time) AS 故障停机
                    ,(rdor.vcomm_failure_time + rdor.close_time +
                     rdor.comm_failure_time) AS 离线停机
                    ,(rdor.work_time - rdor.stop_time) AS 分母
                    ,rdor.dev_no AS org_no
                    ,(CASE
                         WHEN substr(dbi.org_no
                                    ,1
                                    ,2) = '89'
                              OR dbi.org_no = '800001' THEN
                          '000000'
                         ELSE
                          dbi.org_no
                     END) AS super_org_no
              FROM   itl_edw_atms_rpt_open_rate_dev_date rdor
                    ,msl_atms_dev_base_info      dbi
                    ,msl_atms_dev_catalog_table  dct
                    ,msl_atms_dev_type_table     dtt
              WHERE  to_date(replace(replace(rdor.date_time,'20250229','20991231'),'20260229','20991231'),'yyyy-mm-dd') =
                     to_date('${batch_date}'
                            ,'yyyymmdd')
              AND    dbi.dev_catalog = dct.no
              AND    dbi.dev_type = dtt.no
              AND    rdor.dev_no = dbi.no
              AND    dbi.status <> '0' --不含注销设备
              AND    dbi.dev_catalog <> '10007' --排除回单机
                            AND    dct.name in ('ATM','CRS')

              ) t
      
      ),
    tmp_atm_asses_serv_rat_data_m AS
     (SELECT (CASE
                 WHEN 分母 = 0 THEN
                  1
                 ELSE
                  (全功能 + 故障停机 + 离线停机) / 分母
             END) 开机率
            ,(CASE
                 WHEN 分母 = 0 THEN
                  1
                 ELSE
                  全功能 / 分母
             END) 服务率
            ,org_no
            ,super_org_no
      FROM   (SELECT SUM(rdor.full_fun_time) AS 全功能
                    ,SUM(rdor.hard_fault_time + rdor.soft_fault_time +
                         rdor.other_reason_time) AS 故障停机
                    ,SUM(rdor.vcomm_failure_time + rdor.close_time +
                         rdor.comm_failure_time) AS 离线停机
                    ,SUM(rdor.work_time - rdor.stop_time) AS 分母
                    ,rdor.dev_no AS org_no
                    ,(CASE
                         WHEN substr(dbi.org_no
                                    ,1
                                    ,2) = '89'
                              OR dbi.org_no = '800001' THEN
                          '000000'
                         ELSE
                          dbi.org_no
                     END) AS super_org_no
              FROM   itl_edw_atms_rpt_open_rate_dev_date rdor
                    ,msl_atms_dev_base_info      dbi
                    ,msl_atms_dev_catalog_table  dct
                    ,msl_atms_dev_type_table     dtt
              WHERE  to_date(replace(replace(rdor.date_time,'20250229','20991231'),'20260229','20991231'),'yyyy-mm-dd') >=
                     trunc(to_date('${batch_date}'
                                  ,'yyyyMMdd')
                          ,'MM')
              AND    to_date(replace(replace(rdor.date_time,'20250229','20991231'),'20260229','20991231'),'yyyy-mm-dd') <=
                     to_date('${batch_date}'
                             ,'yyyyMMdd')
              AND    dbi.dev_catalog = dct.no
              AND    dbi.dev_type = dtt.no
              AND    rdor.dev_no = dbi.no
              AND    dbi.status <> '0' --不含注销设备
              AND    dbi.dev_catalog <> '10007' --排除回单机
                            AND    dct.name in ('ATM','CRS')

              GROUP  BY rdor.dev_no
                       ,(CASE
                            WHEN substr(dbi.org_no
                                       ,1
                                       ,2) = '89'
                                 OR dbi.org_no = '800001' THEN
                             '000000'
                            ELSE
                             dbi.org_no
                        END)) t
      
      ),
    
    tmp_atm_asses_serv_rat_data_q AS
     (SELECT (CASE
                 WHEN 分母 = 0 THEN
                  1
                 ELSE
                  (全功能 + 故障停机 + 离线停机) / 分母
             END) 开机率
            ,(CASE
                 WHEN 分母 = 0 THEN
                  1
                 ELSE
                  全功能 / 分母
             END) 服务率
            ,org_no
            ,super_org_no
      FROM   (SELECT SUM(rdor.full_fun_time) AS 全功能
                    ,SUM(rdor.hard_fault_time + rdor.soft_fault_time +
                         rdor.other_reason_time) AS 故障停机
                    ,SUM(rdor.vcomm_failure_time + rdor.close_time +
                         rdor.comm_failure_time) AS 离线停机
                    ,SUM(rdor.work_time - rdor.stop_time) AS 分母
                    ,rdor.dev_no AS org_no
                    ,(CASE
                         WHEN substr(dbi.org_no
                                    ,1
                                    ,2) = '89'
                              OR dbi.org_no = '800001' THEN
                          '000000'
                         ELSE
                          dbi.org_no
                     END) AS super_org_no
              FROM   itl_edw_atms_rpt_open_rate_dev_date rdor
                    ,msl_atms_dev_base_info      dbi
                    ,msl_atms_dev_catalog_table  dct
                    ,msl_atms_dev_type_table     dtt
              WHERE  to_date(replace(replace(rdor.date_time,'20250229','20991231'),'20260229','20991231'),'yyyy-mm-dd') >=
                     trunc(to_date('${batch_date}'
                                  ,'yyyymmdd')
                          ,'Q')
              AND    to_date(replace(replace(rdor.date_time,'20250229','20991231'),'20260229','20991231'),'yyyy-mm-dd') <=
                     to_date('${batch_date}'
                             ,'yyyyMMdd')
              AND    dbi.dev_catalog = dct.no
              AND    dbi.dev_type = dtt.no
              AND    rdor.dev_no = dbi.no
              AND    dbi.status <> '0' --不含注销设备
              AND    dbi.dev_catalog <> '10007' --排除回单机
                            AND    dct.name in ('ATM','CRS')

              GROUP  BY rdor.dev_no
                       ,(CASE
                            WHEN substr(dbi.org_no
                                       ,1
                                       ,2) = '89'
                                 OR dbi.org_no = '800001' THEN
                             '000000'
                            ELSE
                             dbi.org_no
                        END)) t
      
      ),
    tmp_atm_asses_serv_rat_data_y AS
     (SELECT (CASE
                 WHEN 分母 = 0 THEN
                  1
                 ELSE
                  (全功能 + 故障停机 + 离线停机) / 分母
             END) 开机率
            ,(CASE
                 WHEN 分母 = 0 THEN
                  1
                 ELSE
                  全功能 / 分母
             END) 服务率
            ,org_no
            ,super_org_no
      FROM   (SELECT SUM(rdor.full_fun_time) AS 全功能
                    ,SUM(rdor.hard_fault_time + rdor.soft_fault_time +
                         rdor.other_reason_time) AS 故障停机
                    ,SUM(rdor.vcomm_failure_time + rdor.close_time +
                         rdor.comm_failure_time) AS 离线停机
                    ,SUM(rdor.work_time - rdor.stop_time) AS 分母
                    ,rdor.dev_no AS org_no
                    ,(CASE
                         WHEN substr(dbi.org_no
                                    ,1
                                    ,2) = '89'
                              OR dbi.org_no = '800001' THEN
                          '000000'
                         ELSE
                          dbi.org_no
                     END) AS super_org_no
              FROM   itl_edw_atms_rpt_open_rate_dev_date rdor
                    ,msl_atms_dev_base_info      dbi
                    ,msl_atms_dev_catalog_table  dct
                    ,msl_atms_dev_type_table     dtt
              WHERE  to_date(replace(replace(rdor.date_time,'20250229','20991231'),'20260229','20991231'),'yyyy-mm-dd') >=
                     trunc(to_date('${batch_date}'
                                  ,'yyyyMMdd')
                          ,'yyyy')
              AND    to_date(replace(replace(rdor.date_time,'20250229','20991231'),'20260229','20991231'),'yyyy-mm-dd') <=
                     to_date('${batch_date}'
                             ,'yyyyMMdd')
              AND    dbi.dev_catalog = dct.no
              AND    dbi.dev_type = dtt.no
              AND    rdor.dev_no = dbi.no
              AND    dbi.status <> '0' --不含注销设备
              AND    dbi.dev_catalog <> '10007' --排除回单机
                            AND    dct.name in ('ATM','CRS')

              GROUP  BY rdor.dev_no
                       ,(CASE
                            WHEN substr(dbi.org_no
                                       ,1
                                       ,2) = '89'
                                 OR dbi.org_no = '800001' THEN
                             '000000'
                            ELSE
                             dbi.org_no
                        END)) t
      
      ),
    tmp_td_initza AS
    --当日数据初始化
     (SELECT t6.index_no
            , --指标编码
             t6.index_name_mcs AS index_name
            , --指标名称
             t2.org_no         AS org_no --柜员号
            ,t2.org_no         AS org_name
            , --存在柜员名称为空的情况，所以统一用柜员号标识
             t2.super_org_no   AS super_org_no
            , --柜员所属支行机构编码
             t2.服务率         AS accu_index_value_d --当日累计
            ,coalesce(t3.服务率
                     ,0) AS accu_index_value_m --当月累计
            ,coalesce(t4.服务率
                     ,0) AS accu_index_value_q --当季累计 
            ,coalesce(t5.服务率
                     ,0) AS accu_index_value_y --当年累计
            ,t6.unit
            , -- 单位
             t6.frequency
            , -- 频度
             NULL             measure_no
            , --- 度量编号
             t6.index_measure -- 度量名称
      FROM   ${idl_schema}.mcyy_orga_para t1
      LEFT   JOIN tmp_atm_asses_serv_rat_data_d t2 --当日
      ON     t1.org_no = t2.super_org_no
      LEFT   JOIN tmp_atm_asses_serv_rat_data_m t3 --当月
      ON     t2.org_no = t3.org_no
      AND    t2.super_org_no = t3.super_org_no
      LEFT   JOIN tmp_atm_asses_serv_rat_data_q t4 --当季
      ON     t2.org_no = t4.org_no
      AND    t2.super_org_no = t4.super_org_no
      LEFT   JOIN tmp_atm_asses_serv_rat_data_y t5 --当年
      ON     t2.org_no = t5.org_no
      AND    t2.super_org_no = t5.super_org_no
      INNER  JOIN ${idl_schema}.mcyy_index_define t6
      ON     'WD041005' = t6.index_no_mcs
      WHERE  length(t1.super_org_no) = 3 --只关联支行
      AND  T2.super_org_no IS NOT NULL
      )
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') etl_dt -- 数据日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
          ,mcyy_bu_analysis_tmp.index_no -- 指标编码
          ,mcyy_bu_analysis_tmp.index_name -- 指标名称
          ,mcyy_bu_analysis_tmp.org_no -- 机构编码
          ,mcyy_bu_analysis_tmp.org_name -- 机构名称
          ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_d) -- 当日累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_q) -- 当季累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_y) -- 当年累计          
          ,mcyy_bu_analysis_tmp.unit -- 单位
          ,mcyy_bu_analysis_tmp.frequency -- 频度
          ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
          ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
          ,'ATM_ASSES_SERV_RAT' source_sys --来源系统
    FROM   (SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,accu_index_value_d
                  ,               accu_index_value_m
                  ,               accu_index_value_q
                  ,               accu_index_value_y
                  ,unit
                  ,frequency
                  ,measure_no
                  ,index_measure
            FROM   tmp_td_initza
            
           
            
            ) mcyy_bu_analysis_tmp
    
    GROUP  BY mcyy_bu_analysis_tmp.index_no -- 指标编码
             ,mcyy_bu_analysis_tmp.index_name -- 指标名称
             ,mcyy_bu_analysis_tmp.org_no -- 机构编码
             ,mcyy_bu_analysis_tmp.org_name -- 机构名称
             ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
             ,mcyy_bu_analysis_tmp.unit -- 单位
             ,mcyy_bu_analysis_tmp.frequency -- 频度
             ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
             ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
    
    ;

COMMIT;

--2.1.1.2 将设备数据汇总成总分支行数据

whenever sqlerror EXIT sql.sqlcode;
INSERT INTO ${idl_schema}.mcyy_bu_analysis
    (etl_dt -- 数据日期
    ,etl_timestamp -- ETL处理时间戳
    ,index_no -- 指标编码
    ,index_name -- 指标名称
    ,org_no -- 机构编码
    ,org_name -- 机构名称
    ,super_org_no -- 上级机构编码
    ,accu_index_value_d -- 当日累计
    ,accu_index_value_m -- 当月累计
    ,accu_index_value_q -- 当季累计
    ,accu_index_value_y -- 当年累计
    ,unit -- 单位
    ,frequency -- 频度
    ,measure_no --- 度量编号
    ,index_measure -- 度量名称
    ,source_sys --来源系统
     )

    WITH tmp_atm_asses_serv_rat_data_person AS
     ( --柜员汇总数据
      SELECT SUM(t.accu_index_value_d) AS index_value_d
             ,SUM(t.accu_index_value_m) AS index_value_m
             ,SUM(t.accu_index_value_q) AS index_value_q
             ,SUM(t.accu_index_value_y) AS index_value_y
             ,t.super_org_no org_no
             ,t.index_no
             ,COUNT(1) AS sums
      FROM   mcyy_bu_analysis t --根据柜员粒度的事实数据基础，汇总成分行总行
      WHERE  to_char(t.etl_dt
                    ,'yyyymmdd') = to_date('${batch_date}'
                                          ,'yyyyMMdd')
      AND    t.index_no IN ('WD041003'
                           ,'WD041005')
      GROUP  BY t.super_org_no, t.index_no
      
      ),
    tmp_td_initza AS
    --当日数据初始化
     (SELECT t4.index_no
            , --指标编码
             t4.index_name_mcs AS index_name
            , --指标名称
             t1.org_no AS org_no --柜员号
            ,t1.org_name AS org_name
            , --柜员名称
             t1.super_org_no AS super_org_no
            , --柜员所属支行机构编码
             CASE
                 WHEN t1.org_no = '000000' THEN
                  SUM(coalesce(t2.index_value_d
                              ,0)) over(PARTITION BY t4.index_no) / SUM(sums) over(PARTITION BY t4.index_no)
                 WHEN length(t1.org_no) = 3 THEN
                  SUM(coalesce(t2.index_value_d
                              ,0))
                  over(PARTITION BY substr(t1.org_no
                             ,1
                             ,3),t4.index_no) / SUM(sums)
                  over(PARTITION BY substr(t1.org_no
                             ,1
                             ,3),t4.index_no)
                 ELSE
                  coalesce(t2.index_value_d
                          ,0) / t2.sums
             END AS accu_index_value_d --当日累计
            ,CASE
                 WHEN t1.org_no = '000000' THEN
                  SUM(coalesce(t2.index_value_m
                              ,0)) over(PARTITION BY t4.index_no) / SUM(sums) over(PARTITION BY t4.index_no)
                 WHEN length(t1.org_no) = 3 THEN
                  SUM(coalesce(t2.index_value_m
                              ,0))
                  over(PARTITION BY substr(t1.org_no
                             ,1
                             ,3),t4.index_no) / SUM(sums)
                  over(PARTITION BY substr(t1.org_no
                             ,1
                             ,3),t4.index_no)
                 ELSE
                  coalesce(t2.index_value_m
                          ,0) / t2.sums
             END AS accu_index_value_m --当月累计        
            ,CASE
                 WHEN t1.org_no = '000000' THEN
                  SUM(coalesce(t2.index_value_q
                              ,0)) over(PARTITION BY t4.index_no) / SUM(sums) over(PARTITION BY t4.index_no)
                 WHEN length(t1.org_no) = 3 THEN
                  SUM(coalesce(t2.index_value_q
                              ,0))
                  over(PARTITION BY substr(t1.org_no
                             ,1
                             ,3),t4.index_no) / SUM(sums)
                  over(PARTITION BY substr(t1.org_no
                             ,1
                             ,3),t4.index_no)
                 ELSE
                  coalesce(t2.index_value_q
                          ,0) / t2.sums
             END AS accu_index_value_q --当季累计        
            ,CASE
                 WHEN t1.org_no = '000000' THEN
                  SUM(coalesce(t2.index_value_y
                              ,0))over(PARTITION BY t4.index_no) / SUM(sums) over(PARTITION BY t4.index_no)
                 WHEN length(t1.org_no) = 3 THEN
                  SUM(coalesce(t2.index_value_y
                              ,0))
                  over(PARTITION BY substr(t1.org_no
                             ,1
                             ,3),t4.index_no) / SUM(sums)
                  over(PARTITION BY substr(t1.org_no
                             ,1
                             ,3),t4.index_no)
                 ELSE
                  coalesce(t2.index_value_y
                          ,0) / t2.sums
             END AS accu_index_value_y --当年累计        
            ,t4.unit
            , -- 单位
             t4.frequency
            , -- 频度
             NULL measure_no
            , --- 度量编号
             t4.index_measure -- 度量名称
      FROM   (SELECT *
              FROM   mcyy_orga_para org_tab
                    ,(SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM   mcyy_index_define t1
                      LEFT   JOIN mcyy_dim_index t2
                      ON     t1.index_no = t2.index_no
                      LEFT   JOIN mcyy_dim_define t3
                      ON     t2.dim_class = t3.dim_class
                      AND    t3.dim_class_name IS NOT NULL
                      WHERE  t1.index_no IN ('WD041003'
                                            ,'WD041005')) dim_tab) t1 --可以考虑放到with子句
      LEFT   JOIN tmp_atm_asses_serv_rat_data_person t2
      ON     t1.org_no = t2.org_no
      AND    t1.index_no = t2.index_no
      INNER  JOIN ${idl_schema}.mcyy_index_define t4
      ON     t1.index_no = t4.index_no_mcs)
    
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') etl_dt -- 数据日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
          ,mcyy_bu_analysis_tmp.index_no -- 指标编码
          ,mcyy_bu_analysis_tmp.index_name -- 指标名称
          ,mcyy_bu_analysis_tmp.org_no -- 机构编码
          ,mcyy_bu_analysis_tmp.org_name -- 机构名称
          ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_d) -- 当日累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_q) -- 当季累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_y) -- 当年累计       
          ,mcyy_bu_analysis_tmp.unit -- 单位
          ,mcyy_bu_analysis_tmp.frequency -- 频度
          ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
          ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
          ,'ATM_ASSES_SERV_RAT' source_sys --来源系统
    FROM   (SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,accu_index_value_d
                  ,accu_index_value_m
                  ,accu_index_value_q
                  ,accu_index_value_y
                  ,unit
                  ,frequency
                  ,measure_no
                  ,index_measure
            FROM   tmp_td_initza) mcyy_bu_analysis_tmp
    
    GROUP  BY mcyy_bu_analysis_tmp.index_no -- 指标编码
             ,mcyy_bu_analysis_tmp.index_name -- 指标名称
             ,mcyy_bu_analysis_tmp.org_no -- 机构编码
             ,mcyy_bu_analysis_tmp.org_name -- 机构名称
             ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码          
             ,mcyy_bu_analysis_tmp.unit -- 单位
             ,mcyy_bu_analysis_tmp.frequency -- 频度
             ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
             ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
    
    ;

COMMIT;


-- 3.1 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mcyy_bu_analysis',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);

