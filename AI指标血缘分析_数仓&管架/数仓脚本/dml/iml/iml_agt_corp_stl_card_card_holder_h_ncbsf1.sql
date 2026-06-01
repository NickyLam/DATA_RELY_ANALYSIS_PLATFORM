/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_corp_stl_card_card_holder_h_ncbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_corp_stl_card_card_holder_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_corp_stl_card_card_holder_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    vouch_id -- 凭证编号
    ,card_no -- 卡号
    ,lp_id -- 法人编号
    ,main_card_flg -- 主卡标志
    ,main_card_card_no -- 主卡卡号
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_cn_name -- 客户中文名称
    ,tel_num -- 电话号码
    ,tran_dt -- 交易日期
    ,core_tran_org_id -- 核心交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_corp_stl_card_card_holder_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_corp_stl_card_card_holder_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_corp_stl_card_card_holder_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_settle_card_holder_info-1
insert into ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_tm(
    vouch_id -- 凭证编号
    ,card_no -- 卡号
    ,lp_id -- 法人编号
    ,main_card_flg -- 主卡标志
    ,main_card_card_no -- 主卡卡号
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_cn_name -- 客户中文名称
    ,tel_num -- 电话号码
    ,tran_dt -- 交易日期
    ,core_tran_org_id -- 核心交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CARD_NO -- 凭证编号
    ,P1.CARD_NO -- 卡号
    ,'9999' -- 法人编号
    ,DECODE(P1.MAIN_CARD_FLAG,'Y','1','N','0') -- 主卡标志
    ,P1.MAIN_CARD_NO -- 主卡卡号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.DOCUMENT_ID -- 证件号码
    ,P1.DOCUMENT_TYPE -- 证件类型代码
    ,P1.CH_CLIENT_NAME -- 客户中文名称
    ,P1.MOBILE_NO -- 电话号码
    ,P1.TRAN_DATE -- 交易日期
    ,P1.TRAN_BRANCH -- 核心交易机构编号
    ,P1.USER_ID -- 交易柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_settle_card_holder_info' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_settle_card_holder_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_tm 
  	                                group by 
  	                                        vouch_id
  	                                        ,card_no
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_cl(
            vouch_id -- 凭证编号
    ,card_no -- 卡号
    ,lp_id -- 法人编号
    ,main_card_flg -- 主卡标志
    ,main_card_card_no -- 主卡卡号
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_cn_name -- 客户中文名称
    ,tel_num -- 电话号码
    ,tran_dt -- 交易日期
    ,core_tran_org_id -- 核心交易机构编号
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_op(
            vouch_id -- 凭证编号
    ,card_no -- 卡号
    ,lp_id -- 法人编号
    ,main_card_flg -- 主卡标志
    ,main_card_card_no -- 主卡卡号
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_cn_name -- 客户中文名称
    ,tel_num -- 电话号码
    ,tran_dt -- 交易日期
    ,core_tran_org_id -- 核心交易机构编号
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.main_card_flg, o.main_card_flg) as main_card_flg -- 主卡标志
    ,nvl(n.main_card_card_no, o.main_card_card_no) as main_card_card_no -- 主卡卡号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cust_cn_name, o.cust_cn_name) as cust_cn_name -- 客户中文名称
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 电话号码
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.core_tran_org_id, o.core_tran_org_id) as core_tran_org_id -- 核心交易机构编号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,case when
            n.vouch_id is null
            and n.card_no is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.vouch_id is null
            and n.card_no is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.vouch_id is null
            and n.card_no is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.vouch_id = n.vouch_id
            and o.card_no = n.card_no
            and o.lp_id = n.lp_id
where (
        o.vouch_id is null
        and o.card_no is null
        and o.lp_id is null
    )
    or (
        n.vouch_id is null
        and n.card_no is null
        and n.lp_id is null
    )
    or (
        o.main_card_flg <> n.main_card_flg
        or o.main_card_card_no <> n.main_card_card_no
        or o.cust_id <> n.cust_id
        or o.cert_no <> n.cert_no
        or o.cert_type_cd <> n.cert_type_cd
        or o.cust_cn_name <> n.cust_cn_name
        or o.tel_num <> n.tel_num
        or o.tran_dt <> n.tran_dt
        or o.core_tran_org_id <> n.core_tran_org_id
        or o.tran_teller_id <> n.tran_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_cl(
            vouch_id -- 凭证编号
    ,card_no -- 卡号
    ,lp_id -- 法人编号
    ,main_card_flg -- 主卡标志
    ,main_card_card_no -- 主卡卡号
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_cn_name -- 客户中文名称
    ,tel_num -- 电话号码
    ,tran_dt -- 交易日期
    ,core_tran_org_id -- 核心交易机构编号
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_op(
            vouch_id -- 凭证编号
    ,card_no -- 卡号
    ,lp_id -- 法人编号
    ,main_card_flg -- 主卡标志
    ,main_card_card_no -- 主卡卡号
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_cn_name -- 客户中文名称
    ,tel_num -- 电话号码
    ,tran_dt -- 交易日期
    ,core_tran_org_id -- 核心交易机构编号
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.vouch_id -- 凭证编号
    ,o.card_no -- 卡号
    ,o.lp_id -- 法人编号
    ,o.main_card_flg -- 主卡标志
    ,o.main_card_card_no -- 主卡卡号
    ,o.cust_id -- 客户编号
    ,o.cert_no -- 证件号码
    ,o.cert_type_cd -- 证件类型代码
    ,o.cust_cn_name -- 客户中文名称
    ,o.tel_num -- 电话号码
    ,o.tran_dt -- 交易日期
    ,o.core_tran_org_id -- 核心交易机构编号
    ,o.tran_teller_id -- 交易柜员编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_bk o
    left join ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_op n
        on
            o.vouch_id = n.vouch_id
            and o.card_no = n.card_no
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_cl d
        on
            o.vouch_id = d.vouch_id
            and o.card_no = d.card_no
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_corp_stl_card_card_holder_h;
--alter table ${iml_schema}.agt_corp_stl_card_card_holder_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_corp_stl_card_card_holder_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_corp_stl_card_card_holder_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_corp_stl_card_card_holder_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_corp_stl_card_card_holder_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_cl;
alter table ${iml_schema}.agt_corp_stl_card_card_holder_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_corp_stl_card_card_holder_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_corp_stl_card_card_holder_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_corp_stl_card_card_holder_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
