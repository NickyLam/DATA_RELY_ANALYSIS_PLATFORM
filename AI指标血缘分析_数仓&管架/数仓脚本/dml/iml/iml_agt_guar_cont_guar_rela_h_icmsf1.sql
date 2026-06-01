/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_guar_cont_guar_rela_h_icmsf1
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
alter table ${iml_schema}.agt_guar_cont_guar_rela_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_guar_cont_guar_rela_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_op purge;
drop table ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    asset_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,guar_id -- 担保物编号
    ,guar_cont_id -- 担保合同编号
    ,rela_status_cd -- 关联状态代码
    ,guar_amt -- 担保金额
    ,curr_cd -- 币种代码
    ,secd_minor_mtg_flg -- 二押标志
    ,pm_rat -- 抵质押率
    ,actl_pm_rat -- 实际抵质押率
    ,fst_mtg_bank_loan_bal -- 一押银行贷款余额
    ,secd_minor_mtg_bank_loan_amt -- 二押银行贷款金额
    ,appl_stage_input_flg -- 申请阶段录入标志
    ,remark -- 备注
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,modif_dt -- 变更日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_guar_cont_guar_rela_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_guar_cont_guar_rela_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_guar_cont_guar_rela_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_guaranty_relative-1
insert into ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_tm(
    asset_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,guar_id -- 担保物编号
    ,guar_cont_id -- 担保合同编号
    ,rela_status_cd -- 关联状态代码
    ,guar_amt -- 担保金额
    ,curr_cd -- 币种代码
    ,secd_minor_mtg_flg -- 二押标志
    ,pm_rat -- 抵质押率
    ,actl_pm_rat -- 实际抵质押率
    ,fst_mtg_bank_loan_bal -- 一押银行贷款余额
    ,secd_minor_mtg_bank_loan_amt -- 二押银行贷款金额
    ,appl_stage_input_flg -- 申请阶段录入标志
    ,remark -- 备注
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,modif_dt -- 变更日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300008'||P1.GUARANTYCONTRACTNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.OBJECTTYPE -- 对象类型名称
    ,P1.OBJECTNO -- 对象编号
    ,P1.CLRID -- 担保物编号
    ,P1.GUARANTYCONTRACTNO -- 担保合同编号
    ,NVL(TRIM(P1.RELATIONSTATUS),'-') -- 关联状态代码
    ,P1.GUARANTYSUM -- 担保金额
    ,NVL(TRIM(P1.GUARANTYCURRENCY),'-') -- 币种代码
    ,NVL(TRIM(P1.ISSECONDMORTGAGE),'-') -- 二押标志
    ,P1.GUARANTYRATE -- 抵质押率
    ,P1.ACTUALGUARANTYRATE -- 实际抵质押率
    ,P1.BALANCEFIRST -- 一押银行贷款余额
    ,P1.BUSINESSSUMFIRST -- 二押银行贷款金额
    ,NVL(TRIM(P1.ISAPPLYINPUT),'-') -- 申请阶段录入标志
    ,P1.REMARK -- 备注
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEDATE -- 变更日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_guaranty_relative' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_guaranty_relative p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_tm 
  	                                group by 
  	                                        asset_id
  	                                        ,lp_id
  	                                        ,obj_type_name
  	                                        ,obj_id
  	                                        ,guar_id
  	                                        ,guar_cont_id
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
        into ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_cl(
            asset_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,guar_id -- 担保物编号
    ,guar_cont_id -- 担保合同编号
    ,rela_status_cd -- 关联状态代码
    ,guar_amt -- 担保金额
    ,curr_cd -- 币种代码
    ,secd_minor_mtg_flg -- 二押标志
    ,pm_rat -- 抵质押率
    ,actl_pm_rat -- 实际抵质押率
    ,fst_mtg_bank_loan_bal -- 一押银行贷款余额
    ,secd_minor_mtg_bank_loan_amt -- 二押银行贷款金额
    ,appl_stage_input_flg -- 申请阶段录入标志
    ,remark -- 备注
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_op(
            asset_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,guar_id -- 担保物编号
    ,guar_cont_id -- 担保合同编号
    ,rela_status_cd -- 关联状态代码
    ,guar_amt -- 担保金额
    ,curr_cd -- 币种代码
    ,secd_minor_mtg_flg -- 二押标志
    ,pm_rat -- 抵质押率
    ,actl_pm_rat -- 实际抵质押率
    ,fst_mtg_bank_loan_bal -- 一押银行贷款余额
    ,secd_minor_mtg_bank_loan_amt -- 二押银行贷款金额
    ,appl_stage_input_flg -- 申请阶段录入标志
    ,remark -- 备注
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.asset_id, o.asset_id) as asset_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.obj_type_name, o.obj_type_name) as obj_type_name -- 对象类型名称
    ,nvl(n.obj_id, o.obj_id) as obj_id -- 对象编号
    ,nvl(n.guar_id, o.guar_id) as guar_id -- 担保物编号
    ,nvl(n.guar_cont_id, o.guar_cont_id) as guar_cont_id -- 担保合同编号
    ,nvl(n.rela_status_cd, o.rela_status_cd) as rela_status_cd -- 关联状态代码
    ,nvl(n.guar_amt, o.guar_amt) as guar_amt -- 担保金额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.secd_minor_mtg_flg, o.secd_minor_mtg_flg) as secd_minor_mtg_flg -- 二押标志
    ,nvl(n.pm_rat, o.pm_rat) as pm_rat -- 抵质押率
    ,nvl(n.actl_pm_rat, o.actl_pm_rat) as actl_pm_rat -- 实际抵质押率
    ,nvl(n.fst_mtg_bank_loan_bal, o.fst_mtg_bank_loan_bal) as fst_mtg_bank_loan_bal -- 一押银行贷款余额
    ,nvl(n.secd_minor_mtg_bank_loan_amt, o.secd_minor_mtg_bank_loan_amt) as secd_minor_mtg_bank_loan_amt -- 二押银行贷款金额
    ,nvl(n.appl_stage_input_flg, o.appl_stage_input_flg) as appl_stage_input_flg -- 申请阶段录入标志
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,case when
            n.asset_id is null
            and n.lp_id is null
            and n.obj_type_name is null
            and n.obj_id is null
            and n.guar_id is null
            and n.guar_cont_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.asset_id is null
            and n.lp_id is null
            and n.obj_type_name is null
            and n.obj_id is null
            and n.guar_id is null
            and n.guar_cont_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.asset_id is null
            and n.lp_id is null
            and n.obj_type_name is null
            and n.obj_id is null
            and n.guar_id is null
            and n.guar_cont_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
            and o.obj_type_name = n.obj_type_name
            and o.obj_id = n.obj_id
            and o.guar_id = n.guar_id
            and o.guar_cont_id = n.guar_cont_id
where (
        o.asset_id is null
        and o.lp_id is null
        and o.obj_type_name is null
        and o.obj_id is null
        and o.guar_id is null
        and o.guar_cont_id is null
    )
    or (
        n.asset_id is null
        and n.lp_id is null
        and n.obj_type_name is null
        and n.obj_id is null
        and n.guar_id is null
        and n.guar_cont_id is null
    )
    or (
        o.rela_status_cd <> n.rela_status_cd
        or o.guar_amt <> n.guar_amt
        or o.curr_cd <> n.curr_cd
        or o.secd_minor_mtg_flg <> n.secd_minor_mtg_flg
        or o.pm_rat <> n.pm_rat
        or o.actl_pm_rat <> n.actl_pm_rat
        or o.fst_mtg_bank_loan_bal <> n.fst_mtg_bank_loan_bal
        or o.secd_minor_mtg_bank_loan_amt <> n.secd_minor_mtg_bank_loan_amt
        or o.appl_stage_input_flg <> n.appl_stage_input_flg
        or o.remark <> n.remark
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_org_id <> n.update_org_id
        or o.update_teller_id <> n.update_teller_id
        or o.modif_dt <> n.modif_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_cl(
            asset_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,guar_id -- 担保物编号
    ,guar_cont_id -- 担保合同编号
    ,rela_status_cd -- 关联状态代码
    ,guar_amt -- 担保金额
    ,curr_cd -- 币种代码
    ,secd_minor_mtg_flg -- 二押标志
    ,pm_rat -- 抵质押率
    ,actl_pm_rat -- 实际抵质押率
    ,fst_mtg_bank_loan_bal -- 一押银行贷款余额
    ,secd_minor_mtg_bank_loan_amt -- 二押银行贷款金额
    ,appl_stage_input_flg -- 申请阶段录入标志
    ,remark -- 备注
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_op(
            asset_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,guar_id -- 担保物编号
    ,guar_cont_id -- 担保合同编号
    ,rela_status_cd -- 关联状态代码
    ,guar_amt -- 担保金额
    ,curr_cd -- 币种代码
    ,secd_minor_mtg_flg -- 二押标志
    ,pm_rat -- 抵质押率
    ,actl_pm_rat -- 实际抵质押率
    ,fst_mtg_bank_loan_bal -- 一押银行贷款余额
    ,secd_minor_mtg_bank_loan_amt -- 二押银行贷款金额
    ,appl_stage_input_flg -- 申请阶段录入标志
    ,remark -- 备注
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.asset_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.obj_type_name -- 对象类型名称
    ,o.obj_id -- 对象编号
    ,o.guar_id -- 担保物编号
    ,o.guar_cont_id -- 担保合同编号
    ,o.rela_status_cd -- 关联状态代码
    ,o.guar_amt -- 担保金额
    ,o.curr_cd -- 币种代码
    ,o.secd_minor_mtg_flg -- 二押标志
    ,o.pm_rat -- 抵质押率
    ,o.actl_pm_rat -- 实际抵质押率
    ,o.fst_mtg_bank_loan_bal -- 一押银行贷款余额
    ,o.secd_minor_mtg_bank_loan_amt -- 二押银行贷款金额
    ,o.appl_stage_input_flg -- 申请阶段录入标志
    ,o.remark -- 备注
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_dt -- 登记日期
    ,o.update_org_id -- 更新机构编号
    ,o.update_teller_id -- 更新柜员编号
    ,o.modif_dt -- 变更日期
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
from ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_bk o
    left join ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_op n
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
            and o.obj_type_name = n.obj_type_name
            and o.obj_id = n.obj_id
            and o.guar_id = n.guar_id
            and o.guar_cont_id = n.guar_cont_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_cl d
        on
            o.asset_id = d.asset_id
            and o.lp_id = d.lp_id
            and o.obj_type_name = d.obj_type_name
            and o.obj_id = d.obj_id
            and o.guar_id = d.guar_id
            and o.guar_cont_id = d.guar_cont_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_guar_cont_guar_rela_h;
--alter table ${iml_schema}.agt_guar_cont_guar_rela_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_guar_cont_guar_rela_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_guar_cont_guar_rela_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_guar_cont_guar_rela_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_guar_cont_guar_rela_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_cl;
alter table ${iml_schema}.agt_guar_cont_guar_rela_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_guar_cont_guar_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_op purge;
drop table ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_guar_cont_guar_rela_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_guar_cont_guar_rela_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
