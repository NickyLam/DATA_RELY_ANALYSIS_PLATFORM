/*
Purpose:    IDL-贷后回收表
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mckb_recover_info
CreateDate: None
FileType:   DML
Logs:
    表英文名： mckb_recover_info
    表中文名： 贷后回收表
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
alter table ${idl_schema}.mckb_recover_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
alter table ${idl_schema}.mckb_recover_info truncate partition p_${batch_date};

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--贷后回收表:插入目标表
insert into ${idl_schema}.mckb_recover_info(
    org_id                                                       --机构编号
    ,org_name                                                    --机构名称
    ,month_loan                                                  --放款月份
    ,distr_amt                                                   --放款金额
    ,loan_bal                                                    --贷款余额
    -- 5
    ,m1_amt                                                      --M1金额
    ,m2_amt                                                      --M2金额
    ,m3_amt                                                      --M3金额
    ,m3plus_amt                                                  --M3+金额
    ,m1_recover_amt                                              --M1催回金额
    -- 10
    ,m2_recover_amt                                              --M2催回金额
    ,m3_recover_amt                                              --M3催回金额
    ,m3plus_recover_amt                                          --M3+催回金额
    ,m1_recover_percent                                          --M1催回率
    ,m2_recover_percent                                          --M2催回率
    -- 15
    ,m3_recover_percent                                          --M3催回率
    ,m3plus_recover_percent                                      --M3+催回率
    ,prod_cls_name                                               --产品分类(易贷，字节)
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
    -- 20
)
select
    null as org_id                                               --None
    ,null as org_name                                            --None
    ,t1.month_loan as month_loan                                 --放款月份
    ,0 as distr_amt                                              --None
    ,t1.loan_amt as loan_bal                                     --放款金额
    -- 5
    ,t1.m1_amt as m1_amt                                         --m1金额
    ,t1.m2_amt as m2_amt                                         --m2金额
    ,t1.m3_amt as m3_amt                                         --m3金额
    ,t1.m3plus_amt as m3plus_amt                                 --m3+金额
    ,t1.m1_recover_amt as m1_recover_amt                         --m1催回金额
    -- 10
    ,t1.m2_recover_amt as m2_recover_amt                         --m2催回金额
    ,t1.m3_recover_amt as m3_recover_amt                         --m3催回金额
    ,t1.m3plus_recover_amt as m3plus_recover_amt                 --m3+催回金额
    ,t1.m1_recover_percent as m1_recover_percent                 --m1催回率
    ,t1.m2_recover_percent as m2_recover_percent                 --m2催回率
    -- 15
    ,t1.m3_recover_percent as m3_recover_percent                 --m3催回率
    ,t1.m3plus_recover_percent as m3plus_recover_percent         --m3+催回率
    ,'易贷' as prod_cls_name                                       --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
    -- 20
 from itl_edw_pcls_yxyd_recover_info t1 --好易贷贷后回收表 

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;

--delete tmp table
whenever sqlerror continue none;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mckb_recover_info', degree => 8, cAScade => true);
