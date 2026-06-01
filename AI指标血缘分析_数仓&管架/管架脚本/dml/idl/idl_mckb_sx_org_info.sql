/*
Purpose:    IDL-整体-进件-授信-易贷
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mckb_sx_org_info
CreateDate: None
FileType:   DML
Logs:
    表英文名： mckb_sx_org_info
    表中文名： 整体-进件-授信-易贷
    创建日期： None
    主键字段： 数据日期
    归属层次： IDL
    归属主题： None
    分区粒度： 
    分析人员： None
    时间粒度： 日
    保留周期： 永久
    描述信息： None
    更新记录:
        2025-07-10    郑沛隆    新建脚本    
        2025-12-09    郑沛隆    删除字段【电核授信件均】    
*/


--设置参数
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- 1.1 create table for exchage
whenever sqlerror continue none;
alter table ${idl_schema}.mckb_sx_org_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
alter table ${idl_schema}.mckb_sx_org_info truncate partition p_${batch_date};

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--整体-进件-授信-易贷:插入目标表
insert into ${idl_schema}.mckb_sx_org_info(
    org_id                                                       --机构编号
    ,org_name                                                    --机构名称
    ,appldt                                                      --申请日期
    ,appl_cnt                                                    --申请笔数
    ,appl_pass_cnt                                               --通过笔数
    -- 5
    ,appl_pass_percent                                           --通过率
    ,crdt_avg                                                    --授信件均
    ,final_pass_repay                                            --平均定价
    ,final_pass_cnt                                              --终审通过笔数
    ,final_passing_rat                                           --终审通过率
    -- 10
    ,tele_pass_cnt                                               --电核通过笔数
    ,tele_pass_percent                                           --电核通过率
    ,face_pass_cnt                                               --面签通过笔数
    ,face_pass_percent                                           --面签通过率
    ,etl_dt                                                      --ETL处理日期
    -- 15
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    null as org_id                                               --None
    ,t1.bank_nm as org_name                                      --分行名称
    ,t1.monthcreated1 as appldt                                  --申请月
    ,t1.appl_cnt as appl_cnt                                     --申请笔数
    ,t1.appl_pass_cnt as appl_pass_cnt                           --申请通过笔数
    -- 5
    ,t1.appl_pass_percent as appl_pass_percent                   --授信通过率（笔数）
    ,t1.final_pass_credit as crdt_avg                            --额度
    ,t1.final_pass_repay as final_pass_repay                     --定价
    ,t1.final_pass_cnt as final_pass_cnt                         --终审通过笔数
    ,t1.final_pass_percent as final_passing_rat                  --终审通过率
    -- 10
    ,t1.tele_pass_cnt as tele_pass_cnt                           --电核通过笔数
    ,t1.tele_pass_percent as tele_pass_percent                   --电核通过率
    ,t1.face_pass_cnt as face_pass_cnt                           --面签通过笔数
    ,t1.face_pass_percent as face_pass_percent                   --面签通过率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 15
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pcls_yxyd_sx_org_info t1 --分行好易贷自营授信表 

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;

--delete tmp table
whenever sqlerror continue none;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mckb_sx_org_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cAScade => true);
