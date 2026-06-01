/*
Purpose:    IDL-贷后入催表
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mckb_loan_collect
CreateDate: None
FileType:   DML
Logs:
    表英文名： MCKB_loan_collect
    表中文名： 贷后入催表
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
alter table ${idl_schema}.MCKB_loan_collect add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
alter table ${idl_schema}.MCKB_loan_collect truncate partition p_${batch_date};

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--贷后入催表:插入目标表
insert into ${idl_schema}.mckb_loan_collect(
    org_id                                                       --机构编号
    ,org_name                                                    --机构名称
    ,month_due                                                   --统计月份
    ,prin_amt                                                    --应收金额
    ,dpd1_amt                                                    --DPD1金额
    -- 5
    ,dpd4_amt                                                    --DPD4金额
    ,dpd8_amt                                                    --DPD8金额
    ,dpd1_cnt                                                    --DPD1客户数
    ,dpd4_cnt                                                    --DPD4客户数
    ,dpd8_cnt                                                    --DPD8客户数
    -- 10
    ,delinquency_rate                                            --入催率
    ,delinquency_3_rate                                          --逾期3天转移率
    ,delinquency_7_rate                                          --逾期7天转移率
    ,prod_cls_name                                               --产品分类(易贷，字节)
    ,etl_dt                                                      --ETL处理日期
    -- 15
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    null as org_id                                               --None
    ,null as org_name                                            --None
    ,t1.month_due as month_due                                   --统计月
    ,t1.prin_amt as prin_amt                                     --应还金额
    ,t1.dpd1_amt as dpd1_amt                                     --dpd1金额
    -- 5
    ,t1.dpd4_amt as dpd4_amt                                     --dpd4金额
    ,t1.dpd8_amt as dpd8_amt                                     --dpd8金额
    ,t1.dpd1_cnt as dpd1_cnt                                     --dpd1客户数
    ,t1.dpd4_cnt as dpd4_cnt                                     --dpd4客户数
    ,t1.dpd8_cnt as dpd8_cnt                                     --dpd8客户数
    -- 10
    ,t1.delinquency_rate as delinquency_rate                     --入催率
    ,t1.delinquency_3_rate as delinquency_3_rate                 --逾期3天转移率
    ,t1.delinquency_7_rate as delinquency_7_rate                 --逾期7天转移率
    ,'易贷' as prod_cls_name                                       --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 15
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pcls_yxyd_loan_collect t1 --好易贷贷后入催表 

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;

--delete tmp table
whenever sqlerror continue none;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mckb_loan_collect', degree => 8, cAScade => true);
