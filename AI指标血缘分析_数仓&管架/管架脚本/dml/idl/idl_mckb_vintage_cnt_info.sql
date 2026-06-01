/*
Purpose:    IDL-vintage_笔数维度
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mckb_vintage_cnt_info
CreateDate: None
FileType:   DML
Logs:
    表英文名： mckb_vintage_cnt_info
    表中文名： vintage_笔数维度
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
alter table ${idl_schema}.mckb_vintage_cnt_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
alter table ${idl_schema}.mckb_vintage_cnt_info truncate partition p_${batch_date};

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--vintage_笔数维度:插入目标表
insert into ${idl_schema}.mckb_vintage_cnt_info(
    org_id                                                       --机构编号
    ,org_name                                                    --机构名称
    ,month_due                                                   --统计月
    ,vintage3plus_mob1_cnt                                       --Mob1_vintage3+逾期人数
    ,vintage3plus_mob2_cnt                                       --Mob2_vintage3+逾期人数
    -- 5
    ,vintage3plus_mob3_cnt                                       --Mob3_vintage3+逾期人数
    ,vintage7plus_mob1_cnt                                       --Mob1_vintage7+逾期人数
    ,vintage7plus_mob2_cnt                                       --Mob2_vintage7+逾期人数
    ,vintage7plus_mob3_cnt                                       --Mob3_vintage7+逾期人数
    ,vintage30plus_mob1_cnt                                      --Mob1_vintage30+逾期人数
    -- 10
    ,vintage30plus_mob2_cnt                                      --Mob2_vintage30+逾期人数
    ,vintage30plus_mob3_cnt                                      --Mob3_vintage30+逾期人数
    ,prod_cls_name                                               --产品分类(易贷,字节)
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
    -- 15
)
select
    null as org_id                                               --None
    ,null as org_name                                            --None
    ,t1.month_loan as month_due                                  --统计月
    ,t1.vintage3plus_mob1_cnt as vintage3plus_mob1_cnt           --Mob1_vintage3+逾期人数
    ,t1.vintage3plus_mob2_cnt as vintage3plus_mob2_cnt           --Mob2_vintage3+逾期人数
    -- 5
    ,t1.vintage3plus_mob3_cnt as vintage3plus_mob3_cnt           --Mob3_vintage3+逾期人数
    ,t1.vintage7plus_mob1_cnt as vintage7plus_mob1_cnt           --Mob1_vintage7+逾期人数
    ,t1.vintage7plus_mob2_cnt as vintage7plus_mob2_cnt           --Mob2_vintage7+逾期人数
    ,t1.vintage7plus_mob3_cnt as vintage7plus_mob3_cnt           --Mob3_vintage7+逾期人数
    ,t1.vintage30plus_mob1_cnt as vintage30plus_mob1_cnt         --Mob1_vintage30+逾期人数
    -- 10
    ,t1.vintage30plus_mob2_cnt as vintage30plus_mob2_cnt         --Mob2_vintage30+逾期人数
    ,t1.vintage30plus_mob3_cnt as vintage30plus_mob3_cnt         --Mob3_vintage30+逾期人数
    ,'易贷' as prod_cls_name                                       --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
    -- 15
 from itl_edw_pcls_yxyd_vintage_cnt_info t1 --好易贷人数账龄分析表 

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;


/*==============第2组==============*/

--vintage_笔数维度:插入目标表
insert into ${idl_schema}.mckb_vintage_cnt_info(
    org_id                                                       --机构编号
    ,org_name                                                    --机构名称
    ,month_due                                                   --统计月
    ,vintage3plus_mob1_cnt                                       --Mob1_vintage3+逾期人数
    ,vintage3plus_mob2_cnt                                       --Mob2_vintage3+逾期人数
    -- 5
    ,vintage3plus_mob3_cnt                                       --Mob3_vintage3+逾期人数
    ,vintage7plus_mob1_cnt                                       --Mob1_vintage7+逾期人数
    ,vintage7plus_mob2_cnt                                       --Mob2_vintage7+逾期人数
    ,vintage7plus_mob3_cnt                                       --Mob3_vintage7+逾期人数
    ,vintage30plus_mob1_cnt                                      --Mob1_vintage30+逾期人数
    -- 10
    ,vintage30plus_mob2_cnt                                      --Mob2_vintage30+逾期人数
    ,vintage30plus_mob3_cnt                                      --Mob3_vintage30+逾期人数
    ,prod_cls_name                                               --产品分类(易贷,字节)
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
    -- 15
)
select
    null as org_id                                               --None
    ,null as org_name                                            --None
    ,t1.monthcreated2 as month_due                               --统计月
    ,t1.vintage3plus_mob1_cnt as vintage3plus_mob1_cnt           --Mob1_vintage3+逾期人数
    ,t1.vintage3plus_mob2_cnt as vintage3plus_mob2_cnt           --Mob2_vintage3+逾期人数
    -- 5
    ,t1.vintage3plus_mob3_cnt as vintage3plus_mob3_cnt           --Mob3_vintage3+逾期人数
    ,t1.vintage7plus_mob1_cnt as vintage7plus_mob1_cnt           --Mob1_vintage7+逾期人数
    ,t1.vintage7plus_mob2_cnt as vintage7plus_mob2_cnt           --Mob2_vintage7+逾期人数
    ,t1.vintage7plus_mob3_cnt as vintage7plus_mob3_cnt           --Mob3_vintage7+逾期人数
    ,t1.vintage30plus_mob1_cnt as vintage30plus_mob1_cnt         --Mob1_vintage30+逾期人数
    -- 10
    ,t1.vintage30plus_mob2_cnt as vintage30plus_mob2_cnt         --Mob2_vintage30+逾期人数
    ,t1.vintage30plus_mob3_cnt as vintage30plus_mob3_cnt         --Mob3_vintage30+逾期人数
    ,'字节' as prod_cls_name                                       --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
    -- 15
 from itl_edw_pcls_byte_vintage_cnt_info t1 --字节小微人数账龄分析表 

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;

--delete tmp table
whenever sqlerror continue none;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mckb_vintage_cnt_info', degree => 8, cAScade => true);
