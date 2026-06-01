/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dep_acct_cotas_info_h_ncbsf1
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
alter table ${iml_schema}.agt_dep_acct_cotas_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_cotas_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cotas_tel_num_one -- 联系人电话号码一
    ,cotas_type_id -- 联系人类型编号
    ,cotas_type_descb -- 联系人类型描述
    ,cust_id -- 客户编号
    ,cotas_cls_cd -- 联系人分类代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_cert_type_cd -- 联系人证件类型代码
    ,cotas_name -- 联系人名称
    ,cotas_tel_num_two -- 联系人电话号码二
    ,data_valid_flg -- 数据有效标志
    ,checker_seq_num -- 查证人序号
    ,spec_cap_checker_flg -- 指定资金查证人标志
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,tran_tm -- 交易时间
    ,cotas_type_cd -- 联系人类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_cotas_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_cotas_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_cotas_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_contact_list
insert into ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cotas_tel_num_one -- 联系人电话号码一
    ,cotas_type_id -- 联系人类型编号
    ,cotas_type_descb -- 联系人类型描述
    ,cust_id -- 客户编号
    ,cotas_cls_cd -- 联系人分类代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_cert_type_cd -- 联系人证件类型代码
    ,cotas_name -- 联系人名称
    ,cotas_tel_num_two -- 联系人电话号码二
    ,data_valid_flg -- 数据有效标志
    ,checker_seq_num -- 查证人序号
    ,spec_cap_checker_flg -- 指定资金查证人标志
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,tran_tm -- 交易时间
    ,cotas_type_cd -- 联系人类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.PHONE_NO1 -- 联系人电话号码一
    ,P1.LINKMAN_TYPE -- 联系人类型编号
    ,P1.LINKMAN_DESC -- 联系人类型描述
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(P1.CONTACT_CLASS),'-') -- 联系人分类代码
    ,P1.DOCUMENT_ID -- 联系人证件号码
    ,nvl(trim(P1.DOCUMENT_TYPE),'0000') -- 联系人证件类型代码
    ,P1.LINKMAN_NAME -- 联系人名称
    ,P1.PHONE_NO2 -- 联系人电话号码二
    ,DECODE(P1.CONTACT_STATUS,'A','1','F','0') -- 数据有效标志
    ,P1.CHECK_CERTIFICATE_ORDER -- 查证人序号
    ,decode(trim(P1.CHECK_CERTIFICATE_FLAG),'Y','1','N','0','-') -- 指定资金查证人标志
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,P1.LAST_CHANGE_USER_ID -- 最后修改柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.CONTACT_TYPE -- 联系人类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_contact_list' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from (select t.*,
       row_number() over(partition by t.internal_key,t.phone_no1,t.linkman_type order by contact_status asc, t.tran_timestamp desc) as rn
      from iol.ncbs_rb_contact_list t
      where t.etl_dt = to_date('${batch_date}','yyyymmdd') 
) p1 
where p1.rn=1
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,acct_id
  	                                        ,cotas_tel_num_one
  	                                        ,cotas_type_id
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
        into ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cotas_tel_num_one -- 联系人电话号码一
    ,cotas_type_id -- 联系人类型编号
    ,cotas_type_descb -- 联系人类型描述
    ,cust_id -- 客户编号
    ,cotas_cls_cd -- 联系人分类代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_cert_type_cd -- 联系人证件类型代码
    ,cotas_name -- 联系人名称
    ,cotas_tel_num_two -- 联系人电话号码二
    ,data_valid_flg -- 数据有效标志
    ,checker_seq_num -- 查证人序号
    ,spec_cap_checker_flg -- 指定资金查证人标志
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,tran_tm -- 交易时间
    ,cotas_type_cd -- 联系人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cotas_tel_num_one -- 联系人电话号码一
    ,cotas_type_id -- 联系人类型编号
    ,cotas_type_descb -- 联系人类型描述
    ,cust_id -- 客户编号
    ,cotas_cls_cd -- 联系人分类代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_cert_type_cd -- 联系人证件类型代码
    ,cotas_name -- 联系人名称
    ,cotas_tel_num_two -- 联系人电话号码二
    ,data_valid_flg -- 数据有效标志
    ,checker_seq_num -- 查证人序号
    ,spec_cap_checker_flg -- 指定资金查证人标志
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,tran_tm -- 交易时间
    ,cotas_type_cd -- 联系人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cotas_tel_num_one, o.cotas_tel_num_one) as cotas_tel_num_one -- 联系人电话号码一
    ,nvl(n.cotas_type_id, o.cotas_type_id) as cotas_type_id -- 联系人类型编号
    ,nvl(n.cotas_type_descb, o.cotas_type_descb) as cotas_type_descb -- 联系人类型描述
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cotas_cls_cd, o.cotas_cls_cd) as cotas_cls_cd -- 联系人分类代码
    ,nvl(n.cotas_cert_no, o.cotas_cert_no) as cotas_cert_no -- 联系人证件号码
    ,nvl(n.cotas_cert_type_cd, o.cotas_cert_type_cd) as cotas_cert_type_cd -- 联系人证件类型代码
    ,nvl(n.cotas_name, o.cotas_name) as cotas_name -- 联系人名称
    ,nvl(n.cotas_tel_num_two, o.cotas_tel_num_two) as cotas_tel_num_two -- 联系人电话号码二
    ,nvl(n.data_valid_flg, o.data_valid_flg) as data_valid_flg -- 数据有效标志
    ,nvl(n.checker_seq_num, o.checker_seq_num) as checker_seq_num -- 查证人序号
    ,nvl(n.spec_cap_checker_flg, o.spec_cap_checker_flg) as spec_cap_checker_flg -- 指定资金查证人标志
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.final_modif_teller_id, o.final_modif_teller_id) as final_modif_teller_id -- 最后修改柜员编号
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.cotas_type_cd, o.cotas_type_cd) as cotas_type_cd -- 联系人类型代码
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.cotas_tel_num_one is null
            and n.cotas_type_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.cotas_tel_num_one is null
            and n.cotas_type_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.cotas_tel_num_one is null
            and n.cotas_type_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.cotas_tel_num_one = n.cotas_tel_num_one
            and o.cotas_type_id = n.cotas_type_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.acct_id is null
        and o.cotas_tel_num_one is null
        and o.cotas_type_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.acct_id is null
        and n.cotas_tel_num_one is null
        and n.cotas_type_id is null
    )
    or (
        o.cotas_type_descb <> n.cotas_type_descb
        or o.cust_id <> n.cust_id
        or o.cotas_cls_cd <> n.cotas_cls_cd
        or o.cotas_cert_no <> n.cotas_cert_no
        or o.cotas_cert_type_cd <> n.cotas_cert_type_cd
        or o.cotas_name <> n.cotas_name
        or o.cotas_tel_num_two <> n.cotas_tel_num_two
        or o.data_valid_flg <> n.data_valid_flg
        or o.checker_seq_num <> n.checker_seq_num
        or o.spec_cap_checker_flg <> n.spec_cap_checker_flg
        or o.final_modif_dt <> n.final_modif_dt
        or o.final_modif_teller_id <> n.final_modif_teller_id
        or o.tran_tm <> n.tran_tm
        or o.cotas_type_cd <> n.cotas_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cotas_tel_num_one -- 联系人电话号码一
    ,cotas_type_id -- 联系人类型编号
    ,cotas_type_descb -- 联系人类型描述
    ,cust_id -- 客户编号
    ,cotas_cls_cd -- 联系人分类代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_cert_type_cd -- 联系人证件类型代码
    ,cotas_name -- 联系人名称
    ,cotas_tel_num_two -- 联系人电话号码二
    ,data_valid_flg -- 数据有效标志
    ,checker_seq_num -- 查证人序号
    ,spec_cap_checker_flg -- 指定资金查证人标志
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,tran_tm -- 交易时间
    ,cotas_type_cd -- 联系人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cotas_tel_num_one -- 联系人电话号码一
    ,cotas_type_id -- 联系人类型编号
    ,cotas_type_descb -- 联系人类型描述
    ,cust_id -- 客户编号
    ,cotas_cls_cd -- 联系人分类代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_cert_type_cd -- 联系人证件类型代码
    ,cotas_name -- 联系人名称
    ,cotas_tel_num_two -- 联系人电话号码二
    ,data_valid_flg -- 数据有效标志
    ,checker_seq_num -- 查证人序号
    ,spec_cap_checker_flg -- 指定资金查证人标志
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,tran_tm -- 交易时间
    ,cotas_type_cd -- 联系人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.acct_id -- 账户编号
    ,o.cotas_tel_num_one -- 联系人电话号码一
    ,o.cotas_type_id -- 联系人类型编号
    ,o.cotas_type_descb -- 联系人类型描述
    ,o.cust_id -- 客户编号
    ,o.cotas_cls_cd -- 联系人分类代码
    ,o.cotas_cert_no -- 联系人证件号码
    ,o.cotas_cert_type_cd -- 联系人证件类型代码
    ,o.cotas_name -- 联系人名称
    ,o.cotas_tel_num_two -- 联系人电话号码二
    ,o.data_valid_flg -- 数据有效标志
    ,o.checker_seq_num -- 查证人序号
    ,o.spec_cap_checker_flg -- 指定资金查证人标志
    ,o.final_modif_dt -- 最后修改日期
    ,o.final_modif_teller_id -- 最后修改柜员编号
    ,o.tran_tm -- 交易时间
    ,o.cotas_type_cd -- 联系人类型代码
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
from ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.cotas_tel_num_one = n.cotas_tel_num_one
            and o.cotas_type_id = n.cotas_type_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.acct_id = d.acct_id
            and o.cotas_tel_num_one = d.cotas_tel_num_one
            and o.cotas_type_id = d.cotas_type_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_dep_acct_cotas_info_h;
--alter table ${iml_schema}.agt_dep_acct_cotas_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_dep_acct_cotas_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_dep_acct_cotas_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_dep_acct_cotas_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_dep_acct_cotas_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_dep_acct_cotas_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dep_acct_cotas_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_dep_acct_cotas_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dep_acct_cotas_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
