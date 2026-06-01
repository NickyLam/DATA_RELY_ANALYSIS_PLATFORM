/*
Purpose:    IDL-整体-拒绝发布
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mckb_sj_info
CreateDate: None
FileType:   DML
Logs:
    表英文名： mckb_sj_info
    表中文名： 整体-拒绝发布
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
                    
*/


--设置参数
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- 1.1 create table for exchage
whenever sqlerror continue none;
alter table ${idl_schema}.mckb_sj_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
alter table ${idl_schema}.mckb_sj_info truncate partition p_${batch_date};

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--整体-拒绝发布:插入目标表
insert into ${idl_schema}.mckb_sj_info(
    org_id                                                       --机构编号
    ,org_name                                                    --机构名称
    ,reject_reason_small                                         --首拒原因
    ,t_1_cnt                                                     --T-1申请笔数
    ,t_2_cnt                                                     --T-2申请笔数
    -- 5
    ,t_3_cnt                                                     --T-3申请笔数
    ,t_4_cnt                                                     --T-4申请笔数
    ,t_5_cnt                                                     --T-5申请笔数
    ,t_6_cnt                                                     --T-6申请笔数
    ,t_7_cnt                                                     --T-7申请笔数
    -- 10
    ,prod_cls_name                                               --产品分类(易贷,字节)
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    null as org_id                                               --None
    ,null as org_name                                            --None
    ,t1.rj_rule as reject_reason_small                           --首拒原因
    ,t1.t_1_cnt as t_1_cnt                                       --t-1申请笔数
    ,t1.t_2_cnt as t_2_cnt                                       --t-2申请笔数
    -- 5
    ,t1.t_3_cnt as t_3_cnt                                       --t-3申请笔数
    ,t1.t_4_cnt as t_4_cnt                                       --t-4申请笔数
    ,t1.t_5_cnt as t_5_cnt                                       --t-5申请笔数
    ,t1.t_6_cnt as t_6_cnt                                       --t-6申请笔数
    ,t1.t_7_cnt as t_7_cnt                                       --t-7申请笔数
    -- 10
    ,'易贷' as prod_cls_name                                       --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pcls_yxyd_sj_info t1 --易贷首拒表 

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;


/*==============第2组==============*/

--整体-拒绝发布:插入目标表
insert into ${idl_schema}.mckb_sj_info(
    org_id                                                       --机构编号
    ,org_name                                                    --机构名称
    ,reject_reason_small                                         --首拒原因
    ,t_1_cnt                                                     --T-1申请笔数
    ,t_2_cnt                                                     --T-2申请笔数
    -- 5
    ,t_3_cnt                                                     --T-3申请笔数
    ,t_4_cnt                                                     --T-4申请笔数
    ,t_5_cnt                                                     --T-5申请笔数
    ,t_6_cnt                                                     --T-6申请笔数
    ,t_7_cnt                                                     --T-7申请笔数
    -- 10
    ,prod_cls_name                                               --产品分类(易贷,字节)
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    null as org_id                                               --None
    ,null as org_name                                            --None
    ,t1.reject_reason_small as reject_reason_small               --首拒原因
    ,t1.t_1_cnt as t_1_cnt                                       --t-1申请笔数
    ,t1.t_2_cnt as t_2_cnt                                       --t-2申请笔数
    -- 5
    ,t1.t_3_cnt as t_3_cnt                                       --t-3申请笔数
    ,t1.t_4_cnt as t_4_cnt                                       --t-4申请笔数
    ,t1.t_5_cnt as t_5_cnt                                       --t-5申请笔数
    ,t1.t_6_cnt as t_6_cnt                                       --t-6申请笔数
    ,t1.t_7_cnt as t_7_cnt                                       --t-7申请笔数
    -- 10
    ,'字节' as prod_cls_name                                       --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pcls_byte_sj_info t1 --字节小微首拒表 

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;

--delete tmp table
whenever sqlerror continue none;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mckb_sj_info', degree => 8, cAScade => true);
