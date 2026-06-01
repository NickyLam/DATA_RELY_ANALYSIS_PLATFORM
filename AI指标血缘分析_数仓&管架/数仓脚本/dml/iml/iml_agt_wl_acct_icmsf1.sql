/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wl_acct_icmsf1
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
alter table ${iml_schema}.agt_wl_acct add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wl_acct_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wl_acct partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_wl_acct_icmsf1_tm purge;
drop table ${iml_schema}.agt_wl_acct_icmsf1_op purge;
drop table ${iml_schema}.agt_wl_acct_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wl_acct_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,acct_name -- 账户名称
    ,acct_type_cd -- 账户类型代码
    ,cap_acct_id -- 资金账户编号
    ,open_bank_name -- 开户行名称
    ,open_bank_num -- 开户行号
    ,open_acct_name -- 开户名称
    ,acct_status_cd -- 账户状态代码
    ,teller_id -- 柜员编号
    ,asset_acct_type_cd -- 资产账户类型代码
    ,bd_card_no -- 绑定卡卡号
    ,bind_mobile_no -- 绑定手机号码
    ,pbc_fin_inst_code -- 人行金融机构编码
    ,obank_card_flg -- 他行卡标志
    ,cust_id -- 客户编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wl_acct partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_wl_acct_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wl_acct partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_wl_acct_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wl_acct partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_wl_account
insert into ${iml_schema}.agt_wl_acct_icmsf1_tm(
    acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,acct_name -- 账户名称
    ,acct_type_cd -- 账户类型代码
    ,cap_acct_id -- 资金账户编号
    ,open_bank_name -- 开户行名称
    ,open_bank_num -- 开户行号
    ,open_acct_name -- 开户名称
    ,acct_status_cd -- 账户状态代码
    ,teller_id -- 柜员编号
    ,asset_acct_type_cd -- 资产账户类型代码
    ,bd_card_no -- 绑定卡卡号
    ,bind_mobile_no -- 绑定手机号码
    ,pbc_fin_inst_code -- 人行金融机构编码
    ,obank_card_flg -- 他行卡标志
    ,cust_id -- 客户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ACCOUNTNO -- 账户编号
    ,'9999' -- 法人编号
    ,P1.ACCOUNTNAME -- 账户名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||TO_CHAR(P1.ACCOUNTTYPE) END -- 账户类型代码
    ,P1.ACCOUNTNUM -- 资金账户编号
    ,P1.OPENBANK -- 开户行名称
    ,P1.OPENBANKNO -- 开户行号
    ,P1.OPENNAME -- 开户名称
    ,NVL(TRIM(P1.ACCOUNTFLG),'-') -- 账户状态代码
    ,P1.CREATEUSER -- 柜员编号
    ,TO_CHAR(P1.ASSETSTYPE) -- 资产账户类型代码
    ,P1.BINDCARDNO -- 绑定卡卡号
    ,P1.BINDPHONE -- 绑定手机号码
    ,P1.FNCINTCODE -- 人行金融机构编码
    ,NVL(TRIM(P1.OTHERBANKFLAG),'-') -- 他行卡标志
    ,P1.ACCTOWNID -- 客户编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wl_account' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wl_account p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ACCOUNTTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_WL_ACCOUNT'
        AND R1.SRC_FIELD_EN_NAME= 'ACCOUNTTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_WL_ACCT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ACCT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_wl_acct_icmsf1_tm 
  	                                group by 
  	                                        acct_id
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
        into ${iml_schema}.agt_wl_acct_icmsf1_cl(
            acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,acct_name -- 账户名称
    ,acct_type_cd -- 账户类型代码
    ,cap_acct_id -- 资金账户编号
    ,open_bank_name -- 开户行名称
    ,open_bank_num -- 开户行号
    ,open_acct_name -- 开户名称
    ,acct_status_cd -- 账户状态代码
    ,teller_id -- 柜员编号
    ,asset_acct_type_cd -- 资产账户类型代码
    ,bd_card_no -- 绑定卡卡号
    ,bind_mobile_no -- 绑定手机号码
    ,pbc_fin_inst_code -- 人行金融机构编码
    ,obank_card_flg -- 他行卡标志
    ,cust_id -- 客户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wl_acct_icmsf1_op(
            acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,acct_name -- 账户名称
    ,acct_type_cd -- 账户类型代码
    ,cap_acct_id -- 资金账户编号
    ,open_bank_name -- 开户行名称
    ,open_bank_num -- 开户行号
    ,open_acct_name -- 开户名称
    ,acct_status_cd -- 账户状态代码
    ,teller_id -- 柜员编号
    ,asset_acct_type_cd -- 资产账户类型代码
    ,bd_card_no -- 绑定卡卡号
    ,bind_mobile_no -- 绑定手机号码
    ,pbc_fin_inst_code -- 人行金融机构编码
    ,obank_card_flg -- 他行卡标志
    ,cust_id -- 客户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.cap_acct_id, o.cap_acct_id) as cap_acct_id -- 资金账户编号
    ,nvl(n.open_bank_name, o.open_bank_name) as open_bank_name -- 开户行名称
    ,nvl(n.open_bank_num, o.open_bank_num) as open_bank_num -- 开户行号
    ,nvl(n.open_acct_name, o.open_acct_name) as open_acct_name -- 开户名称
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.teller_id, o.teller_id) as teller_id -- 柜员编号
    ,nvl(n.asset_acct_type_cd, o.asset_acct_type_cd) as asset_acct_type_cd -- 资产账户类型代码
    ,nvl(n.bd_card_no, o.bd_card_no) as bd_card_no -- 绑定卡卡号
    ,nvl(n.bind_mobile_no, o.bind_mobile_no) as bind_mobile_no -- 绑定手机号码
    ,nvl(n.pbc_fin_inst_code, o.pbc_fin_inst_code) as pbc_fin_inst_code -- 人行金融机构编码
    ,nvl(n.obank_card_flg, o.obank_card_flg) as obank_card_flg -- 他行卡标志
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,case when
            n.acct_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.acct_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.acct_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wl_acct_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_wl_acct_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.acct_id = n.acct_id
            and o.lp_id = n.lp_id
where (
        o.acct_id is null
        and o.lp_id is null
    )
    or (
        n.acct_id is null
        and n.lp_id is null
    )
    or (
        o.acct_name <> n.acct_name
        or o.acct_type_cd <> n.acct_type_cd
        or o.cap_acct_id <> n.cap_acct_id
        or o.open_bank_name <> n.open_bank_name
        or o.open_bank_num <> n.open_bank_num
        or o.open_acct_name <> n.open_acct_name
        or o.acct_status_cd <> n.acct_status_cd
        or o.teller_id <> n.teller_id
        or o.asset_acct_type_cd <> n.asset_acct_type_cd
        or o.bd_card_no <> n.bd_card_no
        or o.bind_mobile_no <> n.bind_mobile_no
        or o.pbc_fin_inst_code <> n.pbc_fin_inst_code
        or o.obank_card_flg <> n.obank_card_flg
        or o.cust_id <> n.cust_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_wl_acct_icmsf1_cl(
            acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,acct_name -- 账户名称
    ,acct_type_cd -- 账户类型代码
    ,cap_acct_id -- 资金账户编号
    ,open_bank_name -- 开户行名称
    ,open_bank_num -- 开户行号
    ,open_acct_name -- 开户名称
    ,acct_status_cd -- 账户状态代码
    ,teller_id -- 柜员编号
    ,asset_acct_type_cd -- 资产账户类型代码
    ,bd_card_no -- 绑定卡卡号
    ,bind_mobile_no -- 绑定手机号码
    ,pbc_fin_inst_code -- 人行金融机构编码
    ,obank_card_flg -- 他行卡标志
    ,cust_id -- 客户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wl_acct_icmsf1_op(
            acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,acct_name -- 账户名称
    ,acct_type_cd -- 账户类型代码
    ,cap_acct_id -- 资金账户编号
    ,open_bank_name -- 开户行名称
    ,open_bank_num -- 开户行号
    ,open_acct_name -- 开户名称
    ,acct_status_cd -- 账户状态代码
    ,teller_id -- 柜员编号
    ,asset_acct_type_cd -- 资产账户类型代码
    ,bd_card_no -- 绑定卡卡号
    ,bind_mobile_no -- 绑定手机号码
    ,pbc_fin_inst_code -- 人行金融机构编码
    ,obank_card_flg -- 他行卡标志
    ,cust_id -- 客户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_id -- 账户编号
    ,o.lp_id -- 法人编号
    ,o.acct_name -- 账户名称
    ,o.acct_type_cd -- 账户类型代码
    ,o.cap_acct_id -- 资金账户编号
    ,o.open_bank_name -- 开户行名称
    ,o.open_bank_num -- 开户行号
    ,o.open_acct_name -- 开户名称
    ,o.acct_status_cd -- 账户状态代码
    ,o.teller_id -- 柜员编号
    ,o.asset_acct_type_cd -- 资产账户类型代码
    ,o.bd_card_no -- 绑定卡卡号
    ,o.bind_mobile_no -- 绑定手机号码
    ,o.pbc_fin_inst_code -- 人行金融机构编码
    ,o.obank_card_flg -- 他行卡标志
    ,o.cust_id -- 客户编号
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
from ${iml_schema}.agt_wl_acct_icmsf1_bk o
    left join ${iml_schema}.agt_wl_acct_icmsf1_op n
        on
            o.acct_id = n.acct_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_wl_acct_icmsf1_cl d
        on
            o.acct_id = d.acct_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_wl_acct;
--alter table ${iml_schema}.agt_wl_acct truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_wl_acct') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_wl_acct drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_wl_acct modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_wl_acct exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_wl_acct_icmsf1_cl;
alter table ${iml_schema}.agt_wl_acct exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_wl_acct_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wl_acct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_wl_acct_icmsf1_tm purge;
drop table ${iml_schema}.agt_wl_acct_icmsf1_op purge;
drop table ${iml_schema}.agt_wl_acct_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_wl_acct_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wl_acct', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
