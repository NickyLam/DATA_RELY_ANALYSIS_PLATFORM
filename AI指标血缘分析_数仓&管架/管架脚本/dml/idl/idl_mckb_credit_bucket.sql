/*
Purpose:    IDL-整体-额度分析
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mckb_credit_bucket
CreateDate: None
FileType:   DML
Logs:
    表英文名： mckb_credit_bucket
    表中文名： 整体-额度分析
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
alter table ${idl_schema}.mckb_credit_bucket add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
alter table ${idl_schema}.mckb_credit_bucket truncate partition p_${batch_date};

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--整体-额度分析:插入目标表
insert into ${idl_schema}.mckb_credit_bucket(
    org_id                                                       --机构编号
    ,org_name                                                    --机构名称
    ,creditline_area                                             --额度分箱
    ,datecreated1                                                --申请日期
    ,appl_cnt                                                    --申请笔数
    -- 5
    ,app_pct                                                     --申请占比
    ,appl_pass_percent                                           --通过率
    ,prod_cls_name                                               --产品分类(易贷,字节)
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
    -- 10
)
select
    null as org_id                                               --None
    ,null as org_name                                            --None
    ,t1.creditline_area as creditline_area                       --额度区间
    ,t1.datecreated1 as datecreated1                             --申请日期
    ,t1.appl_cnt as appl_cnt                                     --申请笔数
    -- 5
    ,t1.appl_pass_cnt as app_pct                                 --申请通过笔数
    ,t1.appl_pass_percent as appl_pass_percent                   --申请通过率
    ,'易贷' as prod_cls_name                                       --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
    -- 10
 from itl_edw_pcls_yxyd_credit_bucket t1 --好易贷自营额度分箱表 

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;


/*==============第2组==============*/

--整体-额度分析:插入目标表
insert into ${idl_schema}.mckb_credit_bucket(
    org_id                                                       --机构编号
    ,org_name                                                    --机构名称
    ,creditline_area                                             --额度分箱
    ,datecreated1                                                --申请日期
    ,appl_cnt                                                    --申请笔数
    -- 5
    ,app_pct                                                     --申请占比
    ,appl_pass_percent                                           --通过率
    ,prod_cls_name                                               --产品分类(易贷,字节)
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
    -- 10
)
select
    null as org_id                                               --None
    ,null as org_name                                            --None
    ,t1.creditline_area as creditline_area                       --额度区间
    ,t1.datecreated1 as datecreated1                             --申请日期
    ,t1.appl_cnt as appl_cnt                                     --申请笔数
    -- 5
    ,t1.appl_pass_cnt as app_pct                                 --申请通过笔数
    ,t1.appl_pass_percent as appl_pass_percent                   --申请通过率
    ,'字节' as prod_cls_name                                       --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
    -- 10
 from itl_edw_pcls_byte_credit_bucket t1 --字节小微额度分箱表 

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;

--delete tmp table
whenever sqlerror continue none;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mckb_credit_bucket', degree => 8, cAScade => true);
