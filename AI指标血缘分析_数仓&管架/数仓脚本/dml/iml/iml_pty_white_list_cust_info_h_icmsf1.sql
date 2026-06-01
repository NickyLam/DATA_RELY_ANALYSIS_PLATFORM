/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_white_list_cust_info_h_icmsf1
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
alter table ${iml_schema}.pty_white_list_cust_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_white_list_cust_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_white_list_cust_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_white_list_cust_info_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_white_list_cust_info_h_icmsf1_op purge;
drop table ${iml_schema}.pty_white_list_cust_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_white_list_cust_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    seq_num -- 序号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,lp_id -- 法人编号
    ,cert_no -- 证件号码
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,list_exchg_cd -- 上市交易所代码
    ,list_src_cd -- 名单来源代码
    ,list_cate_cd -- 名单类别代码
    ,valid_flg -- 有效标志
    ,inclu_rs_descb -- 列入原因描述
    ,work_tel -- 单位电话
    ,mobile_no -- 手机号码
    ,src_descb -- 来源描述
    ,blklist_apv_status_cd -- 黑名单审批状态代码
    ,blklist_descb -- 黑名单描述
    ,apv_status_cd -- 审批状态代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_white_list_cust_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.pty_white_list_cust_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_white_list_cust_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.pty_white_list_cust_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_white_list_cust_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_customer_special-
insert into ${iml_schema}.pty_white_list_cust_info_h_icmsf1_tm(
    seq_num -- 序号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,lp_id -- 法人编号
    ,cert_no -- 证件号码
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,list_exchg_cd -- 上市交易所代码
    ,list_src_cd -- 名单来源代码
    ,list_cate_cd -- 名单类别代码
    ,valid_flg -- 有效标志
    ,inclu_rs_descb -- 列入原因描述
    ,work_tel -- 单位电话
    ,mobile_no -- 手机号码
    ,src_descb -- 来源描述
    ,blklist_apv_status_cd -- 黑名单审批状态代码
    ,blklist_descb -- 黑名单描述
    ,apv_status_cd -- 审批状态代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    NVL(TRIM(P1.SERIALNO),0) -- 序号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,'9999' -- 法人编号
    ,P1.CERTID -- 证件号码
    ,P1.BEGINDATE -- 生效日期
    ,P1.ENDDATE -- 到期日期
    ,nvl(trim(P1.LISTINGPLACE),'000') -- 上市交易所代码
    ,nvl(trim(P1.PROVIDER),'-')  -- 名单来源代码
    ,nvl(trim(P1.SPECIALCUSTOMERTYPE),'-') -- 名单类别代码
    ,nvl(trim(P1.INLISTSTATUS),'-') -- 有效标志
    ,P1.INLISTREASON -- 列入原因描述
    ,P1.COMPANYTEL -- 单位电话
    ,P1.MOBILETEL -- 手机号码
    ,P1.SOURCE -- 来源描述
    ,nvl(trim(P1.ADDAPPROVESTATUS),'-') -- 黑名单审批状态代码
    ,P1.CONTENT -- 黑名单描述
    ,NVL(TRIM(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_customer_special' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_customer_special p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_white_list_cust_info_h_icmsf1_tm 
  	                                group by 
  	                                        seq_num
  	                                        ,cust_id
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
        into ${iml_schema}.pty_white_list_cust_info_h_icmsf1_cl(
            seq_num -- 序号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,lp_id -- 法人编号
    ,cert_no -- 证件号码
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,list_exchg_cd -- 上市交易所代码
    ,list_src_cd -- 名单来源代码
    ,list_cate_cd -- 名单类别代码
    ,valid_flg -- 有效标志
    ,inclu_rs_descb -- 列入原因描述
    ,work_tel -- 单位电话
    ,mobile_no -- 手机号码
    ,src_descb -- 来源描述
    ,blklist_apv_status_cd -- 黑名单审批状态代码
    ,blklist_descb -- 黑名单描述
    ,apv_status_cd -- 审批状态代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_white_list_cust_info_h_icmsf1_op(
            seq_num -- 序号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,lp_id -- 法人编号
    ,cert_no -- 证件号码
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,list_exchg_cd -- 上市交易所代码
    ,list_src_cd -- 名单来源代码
    ,list_cate_cd -- 名单类别代码
    ,valid_flg -- 有效标志
    ,inclu_rs_descb -- 列入原因描述
    ,work_tel -- 单位电话
    ,mobile_no -- 手机号码
    ,src_descb -- 来源描述
    ,blklist_apv_status_cd -- 黑名单审批状态代码
    ,blklist_descb -- 黑名单描述
    ,apv_status_cd -- 审批状态代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.list_exchg_cd, o.list_exchg_cd) as list_exchg_cd -- 上市交易所代码
    ,nvl(n.list_src_cd, o.list_src_cd) as list_src_cd -- 名单来源代码
    ,nvl(n.list_cate_cd, o.list_cate_cd) as list_cate_cd -- 名单类别代码
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.inclu_rs_descb, o.inclu_rs_descb) as inclu_rs_descb -- 列入原因描述
    ,nvl(n.work_tel, o.work_tel) as work_tel -- 单位电话
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.src_descb, o.src_descb) as src_descb -- 来源描述
    ,nvl(n.blklist_apv_status_cd, o.blklist_apv_status_cd) as blklist_apv_status_cd -- 黑名单审批状态代码
    ,nvl(n.blklist_descb, o.blklist_descb) as blklist_descb -- 黑名单描述
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.final_update_org_id, o.final_update_org_id) as final_update_org_id -- 最后更新机构编号
    ,nvl(n.final_update_teller_id, o.final_update_teller_id) as final_update_teller_id -- 最后更新柜员编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.seq_num is null
            and n.cust_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_num is null
            and n.cust_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_num is null
            and n.cust_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_white_list_cust_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.pty_white_list_cust_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.seq_num = n.seq_num
            and o.cust_id = n.cust_id
where (
        o.seq_num is null
        and o.cust_id is null
    )
    or (
        n.seq_num is null
        and n.cust_id is null
    )
    or (
        o.cust_name <> n.cust_name
        or o.lp_id <> n.lp_id
        or o.cert_no <> n.cert_no
        or o.effect_dt <> n.effect_dt
        or o.exp_dt <> n.exp_dt
        or o.list_exchg_cd <> n.list_exchg_cd
        or o.list_src_cd <> n.list_src_cd
        or o.list_cate_cd <> n.list_cate_cd
        or o.valid_flg <> n.valid_flg
        or o.inclu_rs_descb <> n.inclu_rs_descb
        or o.work_tel <> n.work_tel
        or o.mobile_no <> n.mobile_no
        or o.src_descb <> n.src_descb
        or o.blklist_apv_status_cd <> n.blklist_apv_status_cd
        or o.blklist_descb <> n.blklist_descb
        or o.apv_status_cd <> n.apv_status_cd
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_dt <> n.rgst_dt
        or o.final_update_org_id <> n.final_update_org_id
        or o.final_update_teller_id <> n.final_update_teller_id
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_white_list_cust_info_h_icmsf1_cl(
            seq_num -- 序号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,lp_id -- 法人编号
    ,cert_no -- 证件号码
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,list_exchg_cd -- 上市交易所代码
    ,list_src_cd -- 名单来源代码
    ,list_cate_cd -- 名单类别代码
    ,valid_flg -- 有效标志
    ,inclu_rs_descb -- 列入原因描述
    ,work_tel -- 单位电话
    ,mobile_no -- 手机号码
    ,src_descb -- 来源描述
    ,blklist_apv_status_cd -- 黑名单审批状态代码
    ,blklist_descb -- 黑名单描述
    ,apv_status_cd -- 审批状态代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_white_list_cust_info_h_icmsf1_op(
            seq_num -- 序号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,lp_id -- 法人编号
    ,cert_no -- 证件号码
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,list_exchg_cd -- 上市交易所代码
    ,list_src_cd -- 名单来源代码
    ,list_cate_cd -- 名单类别代码
    ,valid_flg -- 有效标志
    ,inclu_rs_descb -- 列入原因描述
    ,work_tel -- 单位电话
    ,mobile_no -- 手机号码
    ,src_descb -- 来源描述
    ,blklist_apv_status_cd -- 黑名单审批状态代码
    ,blklist_descb -- 黑名单描述
    ,apv_status_cd -- 审批状态代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.seq_num -- 序号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.lp_id -- 法人编号
    ,o.cert_no -- 证件号码
    ,o.effect_dt -- 生效日期
    ,o.exp_dt -- 到期日期
    ,o.list_exchg_cd -- 上市交易所代码
    ,o.list_src_cd -- 名单来源代码
    ,o.list_cate_cd -- 名单类别代码
    ,o.valid_flg -- 有效标志
    ,o.inclu_rs_descb -- 列入原因描述
    ,o.work_tel -- 单位电话
    ,o.mobile_no -- 手机号码
    ,o.src_descb -- 来源描述
    ,o.blklist_apv_status_cd -- 黑名单审批状态代码
    ,o.blklist_descb -- 黑名单描述
    ,o.apv_status_cd -- 审批状态代码
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_dt -- 登记日期
    ,o.final_update_org_id -- 最后更新机构编号
    ,o.final_update_teller_id -- 最后更新柜员编号
    ,o.final_update_dt -- 最后更新日期
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
from ${iml_schema}.pty_white_list_cust_info_h_icmsf1_bk o
    left join ${iml_schema}.pty_white_list_cust_info_h_icmsf1_op n
        on
            o.seq_num = n.seq_num
            and o.cust_id = n.cust_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_white_list_cust_info_h_icmsf1_cl d
        on
            o.seq_num = d.seq_num
            and o.cust_id = d.cust_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_white_list_cust_info_h;
--alter table ${iml_schema}.pty_white_list_cust_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_white_list_cust_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_white_list_cust_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_white_list_cust_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_white_list_cust_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.pty_white_list_cust_info_h_icmsf1_cl;
alter table ${iml_schema}.pty_white_list_cust_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.pty_white_list_cust_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_white_list_cust_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_white_list_cust_info_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_white_list_cust_info_h_icmsf1_op purge;
drop table ${iml_schema}.pty_white_list_cust_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_white_list_cust_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_white_list_cust_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
