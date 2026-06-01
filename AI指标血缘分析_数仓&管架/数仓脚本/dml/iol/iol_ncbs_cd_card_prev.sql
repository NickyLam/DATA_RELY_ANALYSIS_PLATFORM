/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cd_card_prev
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ncbs_cd_card_prev_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cd_card_prev
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cd_card_prev_op purge;
drop table ${iol_schema}.ncbs_cd_card_prev_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cd_card_prev_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cd_card_prev where 0=1;

create table ${iol_schema}.ncbs_cd_card_prev_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cd_card_prev where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cd_card_prev_cl(
            card_voucher_status -- 卡凭证状态
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,app_flag -- 附属卡标志
            ,apply_no -- 申请编号
            ,batch_job_no -- 制卡文件批次号
            ,card_cvn -- 卡片cvn信息
            ,card_medium_type -- 卡介质类型
            ,card_pb_union_flag -- 卡折合一标志
            ,card_status -- 卡状态
            ,change_card_num -- 换卡次数
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,query_pwd -- 查询密码
            ,sign_flag -- 是否记名卡
            ,tread_pwd -- 交易密码
            ,issue_date -- 发行日期
            ,tran_timestamp -- 交易时间戳
            ,valid_from_date -- 有效期起始日期
            ,valid_thru_date -- 有效期截止日期
            ,apply_user_id -- 申请柜员
            ,issue_user_id -- 发卡柜员
            ,main_card_no -- 主卡卡号
            ,tran_branch -- 核心交易机构编号
            ,card_cvn_mac -- 卡CVN信息密文MAC值|卡CVN信息密文MAC值
            ,valid_thru_date_mac -- 卡有效期截止日期密文MAC值|卡有效期截止日期密文MAC值
            ,valid_thru_date_pwd -- 卡有效期截止日期密文|卡有效期截止日期密文
            ,card_cvn2_mac -- 卡CVN信息密文MAC值（存储等效二磁信息，包含D的）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cd_card_prev_op(
            card_voucher_status -- 卡凭证状态
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,app_flag -- 附属卡标志
            ,apply_no -- 申请编号
            ,batch_job_no -- 制卡文件批次号
            ,card_cvn -- 卡片cvn信息
            ,card_medium_type -- 卡介质类型
            ,card_pb_union_flag -- 卡折合一标志
            ,card_status -- 卡状态
            ,change_card_num -- 换卡次数
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,query_pwd -- 查询密码
            ,sign_flag -- 是否记名卡
            ,tread_pwd -- 交易密码
            ,issue_date -- 发行日期
            ,tran_timestamp -- 交易时间戳
            ,valid_from_date -- 有效期起始日期
            ,valid_thru_date -- 有效期截止日期
            ,apply_user_id -- 申请柜员
            ,issue_user_id -- 发卡柜员
            ,main_card_no -- 主卡卡号
            ,tran_branch -- 核心交易机构编号
            ,card_cvn_mac -- 卡CVN信息密文MAC值|卡CVN信息密文MAC值
            ,valid_thru_date_mac -- 卡有效期截止日期密文MAC值|卡有效期截止日期密文MAC值
            ,valid_thru_date_pwd -- 卡有效期截止日期密文|卡有效期截止日期密文
            ,card_cvn2_mac -- 卡CVN信息密文MAC值（存储等效二磁信息，包含D的）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.card_voucher_status, o.card_voucher_status) as card_voucher_status -- 卡凭证状态
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.app_flag, o.app_flag) as app_flag -- 附属卡标志
    ,nvl(n.apply_no, o.apply_no) as apply_no -- 申请编号
    ,nvl(n.batch_job_no, o.batch_job_no) as batch_job_no -- 制卡文件批次号
    ,nvl(n.card_cvn, o.card_cvn) as card_cvn -- 卡片cvn信息
    ,nvl(n.card_medium_type, o.card_medium_type) as card_medium_type -- 卡介质类型
    ,nvl(n.card_pb_union_flag, o.card_pb_union_flag) as card_pb_union_flag -- 卡折合一标志
    ,nvl(n.card_status, o.card_status) as card_status -- 卡状态
    ,nvl(n.change_card_num, o.change_card_num) as change_card_num -- 换卡次数
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.dac_value, o.dac_value) as dac_value -- dac值防篡改加密
    ,nvl(n.query_pwd, o.query_pwd) as query_pwd -- 查询密码
    ,nvl(n.sign_flag, o.sign_flag) as sign_flag -- 是否记名卡
    ,nvl(n.tread_pwd, o.tread_pwd) as tread_pwd -- 交易密码
    ,nvl(n.issue_date, o.issue_date) as issue_date -- 发行日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.valid_from_date, o.valid_from_date) as valid_from_date -- 有效期起始日期
    ,nvl(n.valid_thru_date, o.valid_thru_date) as valid_thru_date -- 有效期截止日期
    ,nvl(n.apply_user_id, o.apply_user_id) as apply_user_id -- 申请柜员
    ,nvl(n.issue_user_id, o.issue_user_id) as issue_user_id -- 发卡柜员
    ,nvl(n.main_card_no, o.main_card_no) as main_card_no -- 主卡卡号
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.card_cvn_mac, o.card_cvn_mac) as card_cvn_mac -- 卡CVN信息密文MAC值|卡CVN信息密文MAC值
    ,nvl(n.valid_thru_date_mac, o.valid_thru_date_mac) as valid_thru_date_mac -- 卡有效期截止日期密文MAC值|卡有效期截止日期密文MAC值
    ,nvl(n.valid_thru_date_pwd, o.valid_thru_date_pwd) as valid_thru_date_pwd -- 卡有效期截止日期密文|卡有效期截止日期密文
    ,nvl(n.card_cvn2_mac, o.card_cvn2_mac) as card_cvn2_mac -- 卡CVN信息密文MAC值（存储等效二磁信息，包含D的）
    ,case when
            n.card_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.card_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.card_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cd_card_prev_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cd_card_prev where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.card_no = n.card_no
where (
        o.card_no is null
    )
    or (
        n.card_no is null
    )
    or (
        o.card_voucher_status <> n.card_voucher_status
        or o.client_no <> n.client_no
        or o.prod_type <> n.prod_type
        or o.app_flag <> n.app_flag
        or o.apply_no <> n.apply_no
        or o.batch_job_no <> n.batch_job_no
        or o.card_cvn <> n.card_cvn
        or o.card_medium_type <> n.card_medium_type
        or o.card_pb_union_flag <> n.card_pb_union_flag
        or o.card_status <> n.card_status
        or o.change_card_num <> n.change_card_num
        or o.company <> n.company
        or o.dac_value <> n.dac_value
        or o.query_pwd <> n.query_pwd
        or o.sign_flag <> n.sign_flag
        or o.tread_pwd <> n.tread_pwd
        or o.issue_date <> n.issue_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.valid_from_date <> n.valid_from_date
        or o.valid_thru_date <> n.valid_thru_date
        or o.apply_user_id <> n.apply_user_id
        or o.issue_user_id <> n.issue_user_id
        or o.main_card_no <> n.main_card_no
        or o.tran_branch <> n.tran_branch
        or o.card_cvn_mac <> n.card_cvn_mac
        or o.valid_thru_date_mac <> n.valid_thru_date_mac
        or o.valid_thru_date_pwd <> n.valid_thru_date_pwd
        or o.card_cvn2_mac <> n.card_cvn2_mac
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cd_card_prev_cl(
            card_voucher_status -- 卡凭证状态
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,app_flag -- 附属卡标志
            ,apply_no -- 申请编号
            ,batch_job_no -- 制卡文件批次号
            ,card_cvn -- 卡片cvn信息
            ,card_medium_type -- 卡介质类型
            ,card_pb_union_flag -- 卡折合一标志
            ,card_status -- 卡状态
            ,change_card_num -- 换卡次数
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,query_pwd -- 查询密码
            ,sign_flag -- 是否记名卡
            ,tread_pwd -- 交易密码
            ,issue_date -- 发行日期
            ,tran_timestamp -- 交易时间戳
            ,valid_from_date -- 有效期起始日期
            ,valid_thru_date -- 有效期截止日期
            ,apply_user_id -- 申请柜员
            ,issue_user_id -- 发卡柜员
            ,main_card_no -- 主卡卡号
            ,tran_branch -- 核心交易机构编号
            ,card_cvn_mac -- 卡CVN信息密文MAC值|卡CVN信息密文MAC值
            ,valid_thru_date_mac -- 卡有效期截止日期密文MAC值|卡有效期截止日期密文MAC值
            ,valid_thru_date_pwd -- 卡有效期截止日期密文|卡有效期截止日期密文
            ,card_cvn2_mac -- 卡CVN信息密文MAC值（存储等效二磁信息，包含D的）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cd_card_prev_op(
            card_voucher_status -- 卡凭证状态
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,app_flag -- 附属卡标志
            ,apply_no -- 申请编号
            ,batch_job_no -- 制卡文件批次号
            ,card_cvn -- 卡片cvn信息
            ,card_medium_type -- 卡介质类型
            ,card_pb_union_flag -- 卡折合一标志
            ,card_status -- 卡状态
            ,change_card_num -- 换卡次数
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,query_pwd -- 查询密码
            ,sign_flag -- 是否记名卡
            ,tread_pwd -- 交易密码
            ,issue_date -- 发行日期
            ,tran_timestamp -- 交易时间戳
            ,valid_from_date -- 有效期起始日期
            ,valid_thru_date -- 有效期截止日期
            ,apply_user_id -- 申请柜员
            ,issue_user_id -- 发卡柜员
            ,main_card_no -- 主卡卡号
            ,tran_branch -- 核心交易机构编号
            ,card_cvn_mac -- 卡CVN信息密文MAC值|卡CVN信息密文MAC值
            ,valid_thru_date_mac -- 卡有效期截止日期密文MAC值|卡有效期截止日期密文MAC值
            ,valid_thru_date_pwd -- 卡有效期截止日期密文|卡有效期截止日期密文
            ,card_cvn2_mac -- 卡CVN信息密文MAC值（存储等效二磁信息，包含D的）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.card_voucher_status -- 卡凭证状态
    ,o.card_no -- 卡号
    ,o.client_no -- 客户编号
    ,o.prod_type -- 产品编号
    ,o.app_flag -- 附属卡标志
    ,o.apply_no -- 申请编号
    ,o.batch_job_no -- 制卡文件批次号
    ,o.card_cvn -- 卡片cvn信息
    ,o.card_medium_type -- 卡介质类型
    ,o.card_pb_union_flag -- 卡折合一标志
    ,o.card_status -- 卡状态
    ,o.change_card_num -- 换卡次数
    ,o.company -- 法人
    ,o.dac_value -- dac值防篡改加密
    ,o.query_pwd -- 查询密码
    ,o.sign_flag -- 是否记名卡
    ,o.tread_pwd -- 交易密码
    ,o.issue_date -- 发行日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.valid_from_date -- 有效期起始日期
    ,o.valid_thru_date -- 有效期截止日期
    ,o.apply_user_id -- 申请柜员
    ,o.issue_user_id -- 发卡柜员
    ,o.main_card_no -- 主卡卡号
    ,o.tran_branch -- 核心交易机构编号
    ,o.card_cvn_mac -- 卡CVN信息密文MAC值|卡CVN信息密文MAC值
    ,o.valid_thru_date_mac -- 卡有效期截止日期密文MAC值|卡有效期截止日期密文MAC值
    ,o.valid_thru_date_pwd -- 卡有效期截止日期密文|卡有效期截止日期密文
    ,o.card_cvn2_mac -- 卡CVN信息密文MAC值（存储等效二磁信息，包含D的）
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_cd_card_prev_bk o
    left join ${iol_schema}.ncbs_cd_card_prev_op n
        on
            o.card_no = n.card_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cd_card_prev_cl d
        on
            o.card_no = d.card_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cd_card_prev;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cd_card_prev') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cd_card_prev drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cd_card_prev add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cd_card_prev exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cd_card_prev_cl;
alter table ${iol_schema}.ncbs_cd_card_prev exchange partition p_20991231 with table ${iol_schema}.ncbs_cd_card_prev_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cd_card_prev to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cd_card_prev_op purge;
drop table ${iol_schema}.ncbs_cd_card_prev_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cd_card_prev_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cd_card_prev',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
