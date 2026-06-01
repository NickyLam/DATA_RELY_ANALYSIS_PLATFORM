/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0ntm_card
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.mpcs_a0ntm_card_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0ntm_card
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ntm_card_op purge;
drop table ${iol_schema}.mpcs_a0ntm_card_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_card_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mpcs_a0ntm_card where 0=1;

create table ${iol_schema}.mpcs_a0ntm_card_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mpcs_a0ntm_card where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.mpcs_a0ntm_card_op(
        org -- 机构号
        ,logical_card_no -- 逻辑卡号
        ,acct_no -- 账户编号
        ,cust_id -- 客户编号
        ,corp_id -- 公司ID
        ,product_cd -- 产品代码
        ,app_no -- 申请件编号
        ,barcode -- 申请书条码
        ,bsc_supp_ind -- 主附卡指示
        ,bsc_logiccard_no -- 逻辑卡主卡卡号
        ,owning_branch -- 发卡网点
        ,app_promotion_cd -- 促销码
        ,recom_name -- 推荐人姓名
        ,recom_card_no -- 推荐人介质卡号
        ,setup_date -- 创建日期
        ,user_field21 -- 系统备用域21
        ,activate_ind -- 是否已激活
        ,cancel_date -- 销卡销户日期
        ,latest_card_no -- 最新介质卡号
        ,sales_ind -- 是否接受推广邮件
        ,buser_field22 -- 系统备用域22
        ,represent_name -- 客户经理
        ,pos_pin_verify_ind -- 是否消费凭密
        ,relationship_to_bsc -- 与主卡持卡人关系
        ,card_expire_date -- 卡片有效日期
        ,card_fee_rate -- 年费收取比例
        ,renew_ind -- 续卡标识
        ,renew_reject_cd -- 续卡拒绝原因码
        ,first_card_fee_date -- 首次年费收取日期
        ,last_renewal_date -- 上次续卡日期
        ,first_usage_flag -- 卡片首次用卡标志
        ,next_card_fee_date -- 下个年费收取日期
        ,waive_cardfee_ind -- 是否免除年费
        ,card_fetch_method -- 介质卡领取方式
        ,card_mailer_ind -- 卡片寄送地址标志
        ,jpa_version -- 乐观锁版本号
        ,first_usage_date -- 首次用卡日期
        ,buser_field23 -- 系统备用域23
        ,buser_field24 -- 系统备用域24
        ,buser_field25 -- 系统备用域25
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.org -- 机构号
    ,n.logical_card_no -- 逻辑卡号
    ,n.acct_no -- 账户编号
    ,n.cust_id -- 客户编号
    ,n.corp_id -- 公司ID
    ,n.product_cd -- 产品代码
    ,n.app_no -- 申请件编号
    ,n.barcode -- 申请书条码
    ,n.bsc_supp_ind -- 主附卡指示
    ,n.bsc_logiccard_no -- 逻辑卡主卡卡号
    ,n.owning_branch -- 发卡网点
    ,n.app_promotion_cd -- 促销码
    ,n.recom_name -- 推荐人姓名
    ,n.recom_card_no -- 推荐人介质卡号
    ,n.setup_date -- 创建日期
    ,n.user_field21 -- 系统备用域21
    ,n.activate_ind -- 是否已激活
    ,n.cancel_date -- 销卡销户日期
    ,n.latest_card_no -- 最新介质卡号
    ,n.sales_ind -- 是否接受推广邮件
    ,n.buser_field22 -- 系统备用域22
    ,n.represent_name -- 客户经理
    ,n.pos_pin_verify_ind -- 是否消费凭密
    ,n.relationship_to_bsc -- 与主卡持卡人关系
    ,n.card_expire_date -- 卡片有效日期
    ,n.card_fee_rate -- 年费收取比例
    ,n.renew_ind -- 续卡标识
    ,n.renew_reject_cd -- 续卡拒绝原因码
    ,n.first_card_fee_date -- 首次年费收取日期
    ,n.last_renewal_date -- 上次续卡日期
    ,n.first_usage_flag -- 卡片首次用卡标志
    ,n.next_card_fee_date -- 下个年费收取日期
    ,n.waive_cardfee_ind -- 是否免除年费
    ,n.card_fetch_method -- 介质卡领取方式
    ,n.card_mailer_ind -- 卡片寄送地址标志
    ,n.jpa_version -- 乐观锁版本号
    ,n.first_usage_date -- 首次用卡日期
    ,n.buser_field23 -- 系统备用域23
    ,n.buser_field24 -- 系统备用域24
    ,n.buser_field25 -- 系统备用域25
    ,n.batchfilename -- 批量文件名
    ,n.seqno -- 序列号
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a0ntm_card_bk o
    right join (select * from ${itl_schema}.mpcs_a0ntm_card where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.logical_card_no = n.logical_card_no
where (
        o.logical_card_no is null
    )
    or (
        o.org <> n.org
        or o.acct_no <> n.acct_no
        or o.cust_id <> n.cust_id
        or o.corp_id <> n.corp_id
        or o.product_cd <> n.product_cd
        or o.app_no <> n.app_no
        or o.barcode <> n.barcode
        or o.bsc_supp_ind <> n.bsc_supp_ind
        or o.bsc_logiccard_no <> n.bsc_logiccard_no
        or o.owning_branch <> n.owning_branch
        or o.app_promotion_cd <> n.app_promotion_cd
        or o.recom_name <> n.recom_name
        or o.recom_card_no <> n.recom_card_no
        or o.setup_date <> n.setup_date
        or o.user_field21 <> n.user_field21
        or o.activate_ind <> n.activate_ind
        or o.cancel_date <> n.cancel_date
        or o.latest_card_no <> n.latest_card_no
        or o.sales_ind <> n.sales_ind
        or o.buser_field22 <> n.buser_field22
        or o.represent_name <> n.represent_name
        or o.pos_pin_verify_ind <> n.pos_pin_verify_ind
        or o.relationship_to_bsc <> n.relationship_to_bsc
        or o.card_expire_date <> n.card_expire_date
        or o.card_fee_rate <> n.card_fee_rate
        or o.renew_ind <> n.renew_ind
        or o.renew_reject_cd <> n.renew_reject_cd
        or o.first_card_fee_date <> n.first_card_fee_date
        or o.last_renewal_date <> n.last_renewal_date
        or o.first_usage_flag <> n.first_usage_flag
        or o.next_card_fee_date <> n.next_card_fee_date
        or o.waive_cardfee_ind <> n.waive_cardfee_ind
        or o.card_fetch_method <> n.card_fetch_method
        or o.card_mailer_ind <> n.card_mailer_ind
        or o.jpa_version <> n.jpa_version
        or o.first_usage_date <> n.first_usage_date
        or o.buser_field23 <> n.buser_field23
        or o.buser_field24 <> n.buser_field24
        or o.buser_field25 <> n.buser_field25
        or o.batchfilename <> n.batchfilename
        or o.seqno <> n.seqno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0ntm_card_cl(
            org -- 机构号
        ,logical_card_no -- 逻辑卡号
        ,acct_no -- 账户编号
        ,cust_id -- 客户编号
        ,corp_id -- 公司ID
        ,product_cd -- 产品代码
        ,app_no -- 申请件编号
        ,barcode -- 申请书条码
        ,bsc_supp_ind -- 主附卡指示
        ,bsc_logiccard_no -- 逻辑卡主卡卡号
        ,owning_branch -- 发卡网点
        ,app_promotion_cd -- 促销码
        ,recom_name -- 推荐人姓名
        ,recom_card_no -- 推荐人介质卡号
        ,setup_date -- 创建日期
        ,user_field21 -- 系统备用域21
        ,activate_ind -- 是否已激活
        ,cancel_date -- 销卡销户日期
        ,latest_card_no -- 最新介质卡号
        ,sales_ind -- 是否接受推广邮件
        ,buser_field22 -- 系统备用域22
        ,represent_name -- 客户经理
        ,pos_pin_verify_ind -- 是否消费凭密
        ,relationship_to_bsc -- 与主卡持卡人关系
        ,card_expire_date -- 卡片有效日期
        ,card_fee_rate -- 年费收取比例
        ,renew_ind -- 续卡标识
        ,renew_reject_cd -- 续卡拒绝原因码
        ,first_card_fee_date -- 首次年费收取日期
        ,last_renewal_date -- 上次续卡日期
        ,first_usage_flag -- 卡片首次用卡标志
        ,next_card_fee_date -- 下个年费收取日期
        ,waive_cardfee_ind -- 是否免除年费
        ,card_fetch_method -- 介质卡领取方式
        ,card_mailer_ind -- 卡片寄送地址标志
        ,jpa_version -- 乐观锁版本号
        ,first_usage_date -- 首次用卡日期
        ,buser_field23 -- 系统备用域23
        ,buser_field24 -- 系统备用域24
        ,buser_field25 -- 系统备用域25
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0ntm_card_op(
            org -- 机构号
        ,logical_card_no -- 逻辑卡号
        ,acct_no -- 账户编号
        ,cust_id -- 客户编号
        ,corp_id -- 公司ID
        ,product_cd -- 产品代码
        ,app_no -- 申请件编号
        ,barcode -- 申请书条码
        ,bsc_supp_ind -- 主附卡指示
        ,bsc_logiccard_no -- 逻辑卡主卡卡号
        ,owning_branch -- 发卡网点
        ,app_promotion_cd -- 促销码
        ,recom_name -- 推荐人姓名
        ,recom_card_no -- 推荐人介质卡号
        ,setup_date -- 创建日期
        ,user_field21 -- 系统备用域21
        ,activate_ind -- 是否已激活
        ,cancel_date -- 销卡销户日期
        ,latest_card_no -- 最新介质卡号
        ,sales_ind -- 是否接受推广邮件
        ,buser_field22 -- 系统备用域22
        ,represent_name -- 客户经理
        ,pos_pin_verify_ind -- 是否消费凭密
        ,relationship_to_bsc -- 与主卡持卡人关系
        ,card_expire_date -- 卡片有效日期
        ,card_fee_rate -- 年费收取比例
        ,renew_ind -- 续卡标识
        ,renew_reject_cd -- 续卡拒绝原因码
        ,first_card_fee_date -- 首次年费收取日期
        ,last_renewal_date -- 上次续卡日期
        ,first_usage_flag -- 卡片首次用卡标志
        ,next_card_fee_date -- 下个年费收取日期
        ,waive_cardfee_ind -- 是否免除年费
        ,card_fetch_method -- 介质卡领取方式
        ,card_mailer_ind -- 卡片寄送地址标志
        ,jpa_version -- 乐观锁版本号
        ,first_usage_date -- 首次用卡日期
        ,buser_field23 -- 系统备用域23
        ,buser_field24 -- 系统备用域24
        ,buser_field25 -- 系统备用域25
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.org -- 机构号
    ,o.logical_card_no -- 逻辑卡号
    ,o.acct_no -- 账户编号
    ,o.cust_id -- 客户编号
    ,o.corp_id -- 公司ID
    ,o.product_cd -- 产品代码
    ,o.app_no -- 申请件编号
    ,o.barcode -- 申请书条码
    ,o.bsc_supp_ind -- 主附卡指示
    ,o.bsc_logiccard_no -- 逻辑卡主卡卡号
    ,o.owning_branch -- 发卡网点
    ,o.app_promotion_cd -- 促销码
    ,o.recom_name -- 推荐人姓名
    ,o.recom_card_no -- 推荐人介质卡号
    ,o.setup_date -- 创建日期
    ,o.user_field21 -- 系统备用域21
    ,o.activate_ind -- 是否已激活
    ,o.cancel_date -- 销卡销户日期
    ,o.latest_card_no -- 最新介质卡号
    ,o.sales_ind -- 是否接受推广邮件
    ,o.buser_field22 -- 系统备用域22
    ,o.represent_name -- 客户经理
    ,o.pos_pin_verify_ind -- 是否消费凭密
    ,o.relationship_to_bsc -- 与主卡持卡人关系
    ,o.card_expire_date -- 卡片有效日期
    ,o.card_fee_rate -- 年费收取比例
    ,o.renew_ind -- 续卡标识
    ,o.renew_reject_cd -- 续卡拒绝原因码
    ,o.first_card_fee_date -- 首次年费收取日期
    ,o.last_renewal_date -- 上次续卡日期
    ,o.first_usage_flag -- 卡片首次用卡标志
    ,o.next_card_fee_date -- 下个年费收取日期
    ,o.waive_cardfee_ind -- 是否免除年费
    ,o.card_fetch_method -- 介质卡领取方式
    ,o.card_mailer_ind -- 卡片寄送地址标志
    ,o.jpa_version -- 乐观锁版本号
    ,o.first_usage_date -- 首次用卡日期
    ,o.buser_field23 -- 系统备用域23
    ,o.buser_field24 -- 系统备用域24
    ,o.buser_field25 -- 系统备用域25
    ,o.batchfilename -- 批量文件名
    ,o.seqno -- 序列号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a0ntm_card_bk o
    left join ${iol_schema}.mpcs_a0ntm_card_op n
        on
            o.logical_card_no = n.logical_card_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a0ntm_card;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a0ntm_card') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a0ntm_card drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a0ntm_card add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a0ntm_card exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a0ntm_card_cl;
alter table ${iol_schema}.mpcs_a0ntm_card exchange partition p_20991231 with table ${iol_schema}.mpcs_a0ntm_card_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0ntm_card to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ntm_card_op purge;
drop table ${iol_schema}.mpcs_a0ntm_card_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0ntm_card_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0ntm_card',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
