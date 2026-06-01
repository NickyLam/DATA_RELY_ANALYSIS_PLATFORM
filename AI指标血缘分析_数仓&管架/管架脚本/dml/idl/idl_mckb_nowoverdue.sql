/*
Purpose:    IDL-时点逾期率
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mckb_nowoverdue
CreateDate: None
FileType:   DML
Logs:
    表英文名： mckb_nowoverdue
    表中文名： 时点逾期率
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
alter table ${idl_schema}.mckb_nowoverdue add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
alter table ${idl_schema}.mckb_nowoverdue truncate partition p_${batch_date};

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--时点逾期率:插入目标表
insert into ${idl_schema}.mckb_nowoverdue(
    org_id                                                       --机构编号
    ,org_name                                                    --机构名称
    ,month_due                                                   --放款月
    ,loan_bal                                                    --在贷余额
    ,loan_cnt                                                    --在贷笔数
    -- 5
    ,dpd3plus_cnt                                                --3+逾期笔数
    ,dpd3plus_amt                                                --3+逾期金额
    ,dpd3plus_amt_percent                                        --3+逾期率_amt
    ,dpd7plus_cnt                                                --7+逾期笔数
    ,dpd7plus_amt                                                --7+逾期金额
    -- 10
    ,dpd7plus_amt_percent                                        --7+逾期率_amt
    ,dpd30plus_cnt                                               --30+逾期笔数
    ,dpd30plus_amt                                               --30+逾期金额
    ,dpd30plus_amt_percent                                       --30+逾期率_amt
    ,dpd90plus_cnt                                               --90+逾期笔数
    -- 15
    ,dpd90plus_amt                                               --90+逾期金额
    ,dpd90plus_amt_percent                                       --90+逾期率_amt
    ,prod_cls_name                                               --产品分类(易贷,字节)
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
    -- 20
)
select
    null as org_id                                               --None
    ,null as org_name                                            --None
    ,t1.datecreated as month_due                                 --日期
    ,t1.loan_bal as loan_bal                                     --余额
    ,t1.loan_cnt as loan_cnt                                     --在贷客户数
    -- 5
    ,t1.dpd3plus_cnt as dpd3plus_cnt                             --dpd3+逾期客户数
    ,t1.dpd3plus_amt as dpd3plus_amt                             --dpd3+逾期金额
    ,t1.dpd3plus_amt_percent as dpd3plus_amt_percent             --dpd3+逾期率（金额口径）
    ,t1.dpd7plus_cnt as dpd7plus_cnt                             --dpd7+逾期客户数
    ,t1.dpd7plus_amt as dpd7plus_amt                             --dpd7+逾期金额
    -- 10
    ,t1.dpd7plus_amt_percent as dpd7plus_amt_percent             --dpd7+逾期率（金额口径）
    ,t1.dpd30plus_cnt as dpd30plus_cnt                           --dpd30+逾期客户数
    ,t1.dpd30plus_amt as dpd30plus_amt                           --dpd30+逾期金额
    ,t1.dpd30plus_amt_percent as dpd30plus_amt_percent           --dpd30+逾期率（金额口径）
    ,t1.dpd90plus_cnt as dpd90plus_cnt                           --dpd90+逾期客户数
    -- 15
    ,t1.dpd90plus_amt as dpd90plus_amt                           --dpd90+逾期金额
    ,t1.dpd90plus_amt_percent as dpd90plus_amt_percent           --dpd90+逾期率（金额口径）
    ,'易贷' as prod_cls_name                                       --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
    -- 20
 from itl_edw_pcls_nowoverdue_yxyd t1 --好易贷自营时点逾期表 

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;


/*==============第2组==============*/

--时点逾期率:插入目标表
insert into ${idl_schema}.mckb_nowoverdue(
    org_id                                                       --机构编号
    ,org_name                                                    --机构名称
    ,month_due                                                   --放款月
    ,loan_bal                                                    --在贷余额
    ,loan_cnt                                                    --在贷笔数
    -- 5
    ,dpd3plus_cnt                                                --3+逾期笔数
    ,dpd3plus_amt                                                --3+逾期金额
    ,dpd3plus_amt_percent                                        --3+逾期率_amt
    ,dpd7plus_cnt                                                --7+逾期笔数
    ,dpd7plus_amt                                                --7+逾期金额
    -- 10
    ,dpd7plus_amt_percent                                        --7+逾期率_amt
    ,dpd30plus_cnt                                               --30+逾期笔数
    ,dpd30plus_amt                                               --30+逾期金额
    ,dpd30plus_amt_percent                                       --30+逾期率_amt
    ,dpd90plus_cnt                                               --90+逾期笔数
    -- 15
    ,dpd90plus_amt                                               --90+逾期金额
    ,dpd90plus_amt_percent                                       --90+逾期率_amt
    ,prod_cls_name                                               --产品分类(易贷,字节)
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
    -- 20
)
select
    null as org_id                                               --None
    ,null as org_name                                            --None
    ,t1.datecreated as month_due                                 --日期
    ,t1.loan_bal as loan_bal                                     --余额
    ,t1.loan_cnt as loan_cnt                                     --在贷客户数
    -- 5
    ,t1.dpd3plus_cnt as dpd3plus_cnt                             --dpd3+逾期客户数
    ,t1.dpd3plus_amt as dpd3plus_amt                             --dpd3+逾期金额
    ,t1.dpd3plus_amt_percent as dpd3plus_amt_percent             --dpd3+逾期率（金额口径）
    ,t1.dpd7plus_cnt as dpd7plus_cnt                             --dpd7+逾期客户数
    ,t1.dpd7plus_amt as dpd7plus_amt                             --dpd7+逾期金额
    -- 10
    ,t1.dpd7plus_amt_percent as dpd7plus_amt_percent             --dpd7+逾期率（金额口径）
    ,t1.dpd30plus_cnt as dpd30plus_cnt                           --dpd30+逾期客户数
    ,t1.dpd30plus_amt as dpd30plus_amt                           --dpd30+逾期金额
    ,t1.dpd30plus_amt_percent as dpd30plus_amt_percent           --dpd30+逾期率（金额口径）
    ,t1.dpd90plus_cnt as dpd90plus_cnt                           --dpd90+逾期客户数
    -- 15
    ,t1.dpd90plus_amt as dpd90plus_amt                           --dpd90+逾期金额
    ,t1.dpd90plus_amt_percent as dpd90plus_amt_percent           --dpd90+逾期率（金额口径）
    ,'字节' as prod_cls_name                                       --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
    -- 20
 from itl_edw_pcls_nowoverdue_byte t1 --字节小微时点逾期表 

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;

--delete tmp table
whenever sqlerror continue none;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mckb_nowoverdue', degree => 8, cAScade => true);
