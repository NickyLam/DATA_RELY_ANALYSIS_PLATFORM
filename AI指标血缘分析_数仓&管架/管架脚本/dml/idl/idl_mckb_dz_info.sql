/*
Purpose:    IDL-整体-进件-提现
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mckb_dz_info
CreateDate: None
FileType:   DML
Logs:
    表英文名： mckb_dz_info
    表中文名： 整体-进件-提现
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
        2025-12-09    郑沛隆    删除字段【平均定价】、【支用比例】    
*/


--设置参数
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- 1.1 create table for exchage
whenever sqlerror continue none;
alter table ${idl_schema}.mckb_dz_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
alter table ${idl_schema}.mckb_dz_info truncate partition p_${batch_date};

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--整体-进件-提现:插入目标表
insert into ${idl_schema}.mckb_dz_info(
    org_id                                                       --机构编号
    ,org_name                                                    --机构名称
    ,draw_dt                                                     --动支日期
    ,draw_cnt                                                    --申请笔数
    ,draw_pass_cnt                                               --通过笔数
    -- 5
    ,draw_pass_percent                                           --通过率
    ,draw_amt                                                    --总放款
    ,draw_amt_avg                                                --放款件均
    ,bal                                                         --在贷余额
    ,prod_cls_name                                               --产品分类(易贷,字节)
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    null as org_id                                               --None
    ,null as org_name                                            --None
    ,t1.draw_dt as draw_dt                                       --动支日期
    ,t1.draw_cnt as draw_cnt                                     --动支笔数
    ,t1.draw_pass_cnt as draw_pass_cnt                           --动支成功笔数
    -- 5
    ,t1.draw_pass_percent as draw_pass_percent                   --动支成功率
    ,t1.draw_amt as draw_amt                                     --放款金额
    ,t1.draw_amt_avg as draw_amt_avg                             --笔均放款金额
    ,t1.bal as bal                                               --贷款余额
    ,'易贷' as prod_cls_name                                       --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pcls_yxyd_dz_info t1 --好易贷自营动支表 

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;


/*==============第2组==============*/

--整体-进件-提现:插入目标表
insert into ${idl_schema}.mckb_dz_info(
    org_id                                                       --机构编号
    ,org_name                                                    --机构名称
    ,draw_dt                                                     --动支日期
    ,draw_cnt                                                    --申请笔数
    ,draw_pass_cnt                                               --通过笔数
    -- 5
    ,draw_pass_percent                                           --通过率
    ,draw_amt                                                    --总放款
    ,draw_amt_avg                                                --放款件均
    ,bal                                                         --在贷余额
    ,prod_cls_name                                               --产品分类(易贷,字节)
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    null as org_id                                               --None
    ,null as org_name                                            --None
    ,t1.draw_dt as draw_dt                                       --动支日期
    ,t1.draw_cnt as draw_cnt                                     --动支笔数
    ,t1.draw_pass_cnt as draw_pass_cnt                           --动支成功笔数
    -- 5
    ,t1.draw_pass_percent as draw_pass_percent                   --动支成功率
    ,t1.loan_amt as draw_amt                                     --放款金额
    ,t1.loan_amt_avg as draw_amt_avg                             --笔均放款金额
    ,t1.loan_bal as bal                                          --贷款余额
    ,'字节' as prod_cls_name                                       --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pcls_byte_dz_info t1 --字节小微动支表 

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;

--delete tmp table
whenever sqlerror continue none;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mckb_dz_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cAScade => true);
