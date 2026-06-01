/*
Purpose:    IDL-整体-进件-授信-字节
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mckb_sx_info
CreateDate: None
FileType:   DML
Logs:
    表英文名： mckb_sx_info
    表中文名： 整体-进件-授信-字节
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
alter table ${idl_schema}.mckb_sx_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
alter table ${idl_schema}.mckb_sx_info truncate partition p_${batch_date};

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--整体-进件-授信-字节:插入目标表
insert into ${idl_schema}.mckb_sx_info(
    org_id                                                       --机构编号
    ,org_name                                                    --机构名称
    ,appl_dt                                                     --申请日期
    ,appl_cnt                                                    --申请笔数
    ,appl_pass_cnt                                               --通过笔数
    -- 5
    ,appl_pass_percent                                           --通过率
    ,credit_amount_avg                                           --授信件均
    ,rate                                                        --平均定价
    ,avg_lmt                                                     --平均额度
    ,prod_cls_name                                               --产品分类(字节,字节助贷,字节联贷)
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    null as org_id                                               --None
    ,null as org_name                                            --None
    ,t1.appl_dt as appl_dt                                       --申请日期
    ,t1.appl_cnt as appl_cnt                                     --申请笔数
    ,t1.appl_pass_cnt as appl_pass_cnt                           --申请通过笔数
    -- 5
    ,t1.appl_pass_percent as appl_pass_percent                   --授信通过率（笔数）
    ,t1.credit_amount_avg as credit_amount_avg                   --笔均授信金额
    ,t1.rate as rate                                             --定价
    ,t1.credit_amount as avg_lmt                                 --授信金额
    ,'字节' as prod_cls_name                                       --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pcls_byte_sx_info t1 --字节小微授信表 

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;


/*==============第2组==============*/

--整体-进件-授信-字节:插入目标表
insert into ${idl_schema}.mckb_sx_info(
    org_id                                                       --机构编号
    ,org_name                                                    --机构名称
    ,appl_dt                                                     --申请日期
    ,appl_cnt                                                    --申请笔数
    ,appl_pass_cnt                                               --通过笔数
    -- 5
    ,appl_pass_percent                                           --通过率
    ,credit_amount_avg                                           --授信件均
    ,rate                                                        --平均定价
    ,avg_lmt                                                     --平均额度
    ,prod_cls_name                                               --产品分类(字节,字节助贷,字节联贷)
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    null as org_id                                               --None
    ,null as org_name                                            --None
    ,t1.appl_dt as appl_dt                                       --申请日期
    ,t1.appl_cnt as appl_cnt                                     --申请笔数
    ,t1.appl_pass_cnt as appl_pass_cnt                           --申请通过笔数
    -- 5
    ,t1.appl_pass_percent as appl_pass_percent                   --授信通过率（笔数）
    ,t1.credit_amount_avg as credit_amount_avg                   --笔均授信金额
    ,t1.rate as rate                                             --定价
    ,t1.credit_amount as avg_lmt                                 --授信金额
    ,'字节联贷' as prod_cls_name                                     --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pcls_byte_ld_sx_info t1 --字节小微联贷授信表 

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;


/*==============第3组==============*/

--整体-进件-授信-字节:插入目标表
insert into ${idl_schema}.mckb_sx_info(
    org_id                                                       --机构编号
    ,org_name                                                    --机构名称
    ,appl_dt                                                     --申请日期
    ,appl_cnt                                                    --申请笔数
    ,appl_pass_cnt                                               --通过笔数
    -- 5
    ,appl_pass_percent                                           --通过率
    ,credit_amount_avg                                           --授信件均
    ,rate                                                        --平均定价
    ,avg_lmt                                                     --平均额度
    ,prod_cls_name                                               --产品分类(字节,字节助贷,字节联贷)
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    null as org_id                                               --None
    ,null as org_name                                            --None
    ,t1.appl_dt as appl_dt                                       --申请日期
    ,t1.appl_cnt as appl_cnt                                     --申请笔数
    ,t1.appl_pass_cnt as appl_pass_cnt                           --申请通过笔数
    -- 5
    ,t1.appl_pass_percent as appl_pass_percent                   --授信通过率（笔数）
    ,t1.credit_amount_avg as credit_amount_avg                   --笔均授信金额
    ,t1.rate as rate                                             --定价
    ,t1.credit_amount as avg_lmt                                 --授信金额
    ,'字节助贷' as prod_cls_name                                     --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pcls_byte_zd_sx_info t1 --字节小微助贷授信表 

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;

--delete tmp table
whenever sqlerror continue none;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mckb_sx_info', degree => 8, cAScade => true);
