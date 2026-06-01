/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_crdt_lmt_seg_h_icmsf1
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
alter table ${iml_schema}.agt_crdt_lmt_seg_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_crdt_lmt_seg_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_op purge;
drop table ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seg_lmt_id -- 切分额度编号
    ,lmt_id -- 额度编号
    ,up_level_seg_lmt_id -- 上层切分额度编号
    ,seg_type_cd -- 切分类型代码
    ,curr_cd -- 币种代码
    ,spcl_seg_lmt_flg -- 专项切分额度标志
    ,circl_flg -- 循环标志
    ,seg_obj_id -- 切分对象编号
    ,seg_obj_type_name -- 切分对象类型名称
    ,seg_open_amt -- 切分敞口金额
    ,seg_nmal_amt -- 切分名义金额
    ,ocup_nmal_amt -- 占用名义金额
    ,ocup_open_amt -- 占用敞口金额
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,comn_open_amt -- 一般敞口金额
    ,comn_risk_aval_open_amt -- 一般风险可用敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,class_low_risk_aval_open_amt -- 类低风险可用敞口金额
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_crdt_lmt_seg_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_crdt_lmt_seg_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_crdt_lmt_seg_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_cl_credit_divide-1
insert into ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seg_lmt_id -- 切分额度编号
    ,lmt_id -- 额度编号
    ,up_level_seg_lmt_id -- 上层切分额度编号
    ,seg_type_cd -- 切分类型代码
    ,curr_cd -- 币种代码
    ,spcl_seg_lmt_flg -- 专项切分额度标志
    ,circl_flg -- 循环标志
    ,seg_obj_id -- 切分对象编号
    ,seg_obj_type_name -- 切分对象类型名称
    ,seg_open_amt -- 切分敞口金额
    ,seg_nmal_amt -- 切分名义金额
    ,ocup_nmal_amt -- 占用名义金额
    ,ocup_open_amt -- 占用敞口金额
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,comn_open_amt -- 一般敞口金额
    ,comn_risk_aval_open_amt -- 一般风险可用敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,class_low_risk_aval_open_amt -- 类低风险可用敞口金额
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300010'||P1.CREDITNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.DIVIDENO -- 切分额度编号
    ,P1.CREDITNO -- 额度编号
    ,P1.PARENTDIVIDENO -- 上层切分额度编号
    ,nvl(trim(P1.DIVIDETYPE),'-') -- 切分类型代码
    ,nvl(trim(P1.DIVIDECURRENCY),'-') -- 币种代码
    ,decode(trim(P1.IFEXCLUSIVECREDIT),'Y','1','N','0','','-',trim(P1.IFEXCLUSIVECREDIT)) -- 专项切分额度标志
    ,decode(trim(P1.RECYCLABLE),'Y','1','N','0','','-',trim(P1.RECYCLABLE)) -- 循环标志
    ,P1.OBJECTNO -- 切分对象编号
    ,P1.OBJECTNAME -- 切分对象类型名称
    ,P1.EXPOSUREAMOUNT -- 切分敞口金额
    ,P1.NOMINALAMOUNT -- 切分名义金额
    ,P1.OCCUPYNOMINALAMOUNT -- 占用名义金额
    ,P1.OCCUPYEXPOSUREAMOUNT -- 占用敞口金额
    ,P1.AVAILABLENOMINALSUM -- 可用名义金额
    ,P1.AVAILABLEEXPOSURESUM -- 可用敞口金额
    ,P1.RISKEXPOSURESUM -- 一般敞口金额
    ,P1.AVAILABLERISKEXPOSURESUM -- 一般风险可用敞口金额
    ,P1.LOWRISKEXPOSURESUM -- 类低风险敞口金额
    ,P1.AVAILABLELOWRISKEXPOSURESUM -- 类低风险可用敞口金额
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,to_date(substr (P1.INPUTDATE,1,9)) -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_cl_credit_divide' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_cl_credit_divide p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,seg_lmt_id
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
        into ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seg_lmt_id -- 切分额度编号
    ,lmt_id -- 额度编号
    ,up_level_seg_lmt_id -- 上层切分额度编号
    ,seg_type_cd -- 切分类型代码
    ,curr_cd -- 币种代码
    ,spcl_seg_lmt_flg -- 专项切分额度标志
    ,circl_flg -- 循环标志
    ,seg_obj_id -- 切分对象编号
    ,seg_obj_type_name -- 切分对象类型名称
    ,seg_open_amt -- 切分敞口金额
    ,seg_nmal_amt -- 切分名义金额
    ,ocup_nmal_amt -- 占用名义金额
    ,ocup_open_amt -- 占用敞口金额
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,comn_open_amt -- 一般敞口金额
    ,comn_risk_aval_open_amt -- 一般风险可用敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,class_low_risk_aval_open_amt -- 类低风险可用敞口金额
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seg_lmt_id -- 切分额度编号
    ,lmt_id -- 额度编号
    ,up_level_seg_lmt_id -- 上层切分额度编号
    ,seg_type_cd -- 切分类型代码
    ,curr_cd -- 币种代码
    ,spcl_seg_lmt_flg -- 专项切分额度标志
    ,circl_flg -- 循环标志
    ,seg_obj_id -- 切分对象编号
    ,seg_obj_type_name -- 切分对象类型名称
    ,seg_open_amt -- 切分敞口金额
    ,seg_nmal_amt -- 切分名义金额
    ,ocup_nmal_amt -- 占用名义金额
    ,ocup_open_amt -- 占用敞口金额
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,comn_open_amt -- 一般敞口金额
    ,comn_risk_aval_open_amt -- 一般风险可用敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,class_low_risk_aval_open_amt -- 类低风险可用敞口金额
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
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
    ,nvl(n.seg_lmt_id, o.seg_lmt_id) as seg_lmt_id -- 切分额度编号
    ,nvl(n.lmt_id, o.lmt_id) as lmt_id -- 额度编号
    ,nvl(n.up_level_seg_lmt_id, o.up_level_seg_lmt_id) as up_level_seg_lmt_id -- 上层切分额度编号
    ,nvl(n.seg_type_cd, o.seg_type_cd) as seg_type_cd -- 切分类型代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.spcl_seg_lmt_flg, o.spcl_seg_lmt_flg) as spcl_seg_lmt_flg -- 专项切分额度标志
    ,nvl(n.circl_flg, o.circl_flg) as circl_flg -- 循环标志
    ,nvl(n.seg_obj_id, o.seg_obj_id) as seg_obj_id -- 切分对象编号
    ,nvl(n.seg_obj_type_name, o.seg_obj_type_name) as seg_obj_type_name -- 切分对象类型名称
    ,nvl(n.seg_open_amt, o.seg_open_amt) as seg_open_amt -- 切分敞口金额
    ,nvl(n.seg_nmal_amt, o.seg_nmal_amt) as seg_nmal_amt -- 切分名义金额
    ,nvl(n.ocup_nmal_amt, o.ocup_nmal_amt) as ocup_nmal_amt -- 占用名义金额
    ,nvl(n.ocup_open_amt, o.ocup_open_amt) as ocup_open_amt -- 占用敞口金额
    ,nvl(n.aval_nmal_amt, o.aval_nmal_amt) as aval_nmal_amt -- 可用名义金额
    ,nvl(n.aval_open_amt, o.aval_open_amt) as aval_open_amt -- 可用敞口金额
    ,nvl(n.comn_open_amt, o.comn_open_amt) as comn_open_amt -- 一般敞口金额
    ,nvl(n.comn_risk_aval_open_amt, o.comn_risk_aval_open_amt) as comn_risk_aval_open_amt -- 一般风险可用敞口金额
    ,nvl(n.class_low_risk_open_amt, o.class_low_risk_open_amt) as class_low_risk_open_amt -- 类低风险敞口金额
    ,nvl(n.class_low_risk_aval_open_amt, o.class_low_risk_aval_open_amt) as class_low_risk_aval_open_amt -- 类低风险可用敞口金额
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.seg_lmt_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.seg_lmt_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.seg_lmt_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.seg_lmt_id = n.seg_lmt_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.seg_lmt_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.seg_lmt_id is null
    )
    or (
        o.lmt_id <> n.lmt_id
        or o.up_level_seg_lmt_id <> n.up_level_seg_lmt_id
        or o.seg_type_cd <> n.seg_type_cd
        or o.curr_cd <> n.curr_cd
        or o.spcl_seg_lmt_flg <> n.spcl_seg_lmt_flg
        or o.circl_flg <> n.circl_flg
        or o.seg_obj_id <> n.seg_obj_id
        or o.seg_obj_type_name <> n.seg_obj_type_name
        or o.seg_open_amt <> n.seg_open_amt
        or o.seg_nmal_amt <> n.seg_nmal_amt
        or o.ocup_nmal_amt <> n.ocup_nmal_amt
        or o.ocup_open_amt <> n.ocup_open_amt
        or o.aval_nmal_amt <> n.aval_nmal_amt
        or o.aval_open_amt <> n.aval_open_amt
        or o.comn_open_amt <> n.comn_open_amt
        or o.comn_risk_aval_open_amt <> n.comn_risk_aval_open_amt
        or o.class_low_risk_open_amt <> n.class_low_risk_open_amt
        or o.class_low_risk_aval_open_amt <> n.class_low_risk_aval_open_amt
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seg_lmt_id -- 切分额度编号
    ,lmt_id -- 额度编号
    ,up_level_seg_lmt_id -- 上层切分额度编号
    ,seg_type_cd -- 切分类型代码
    ,curr_cd -- 币种代码
    ,spcl_seg_lmt_flg -- 专项切分额度标志
    ,circl_flg -- 循环标志
    ,seg_obj_id -- 切分对象编号
    ,seg_obj_type_name -- 切分对象类型名称
    ,seg_open_amt -- 切分敞口金额
    ,seg_nmal_amt -- 切分名义金额
    ,ocup_nmal_amt -- 占用名义金额
    ,ocup_open_amt -- 占用敞口金额
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,comn_open_amt -- 一般敞口金额
    ,comn_risk_aval_open_amt -- 一般风险可用敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,class_low_risk_aval_open_amt -- 类低风险可用敞口金额
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seg_lmt_id -- 切分额度编号
    ,lmt_id -- 额度编号
    ,up_level_seg_lmt_id -- 上层切分额度编号
    ,seg_type_cd -- 切分类型代码
    ,curr_cd -- 币种代码
    ,spcl_seg_lmt_flg -- 专项切分额度标志
    ,circl_flg -- 循环标志
    ,seg_obj_id -- 切分对象编号
    ,seg_obj_type_name -- 切分对象类型名称
    ,seg_open_amt -- 切分敞口金额
    ,seg_nmal_amt -- 切分名义金额
    ,ocup_nmal_amt -- 占用名义金额
    ,ocup_open_amt -- 占用敞口金额
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,comn_open_amt -- 一般敞口金额
    ,comn_risk_aval_open_amt -- 一般风险可用敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,class_low_risk_aval_open_amt -- 类低风险可用敞口金额
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
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
    ,o.seg_lmt_id -- 切分额度编号
    ,o.lmt_id -- 额度编号
    ,o.up_level_seg_lmt_id -- 上层切分额度编号
    ,o.seg_type_cd -- 切分类型代码
    ,o.curr_cd -- 币种代码
    ,o.spcl_seg_lmt_flg -- 专项切分额度标志
    ,o.circl_flg -- 循环标志
    ,o.seg_obj_id -- 切分对象编号
    ,o.seg_obj_type_name -- 切分对象类型名称
    ,o.seg_open_amt -- 切分敞口金额
    ,o.seg_nmal_amt -- 切分名义金额
    ,o.ocup_nmal_amt -- 占用名义金额
    ,o.ocup_open_amt -- 占用敞口金额
    ,o.aval_nmal_amt -- 可用名义金额
    ,o.aval_open_amt -- 可用敞口金额
    ,o.comn_open_amt -- 一般敞口金额
    ,o.comn_risk_aval_open_amt -- 一般风险可用敞口金额
    ,o.class_low_risk_open_amt -- 类低风险敞口金额
    ,o.class_low_risk_aval_open_amt -- 类低风险可用敞口金额
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
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
from ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_bk o
    left join ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.seg_lmt_id = n.seg_lmt_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.seg_lmt_id = d.seg_lmt_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_crdt_lmt_seg_h;
--alter table ${iml_schema}.agt_crdt_lmt_seg_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_crdt_lmt_seg_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_crdt_lmt_seg_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_crdt_lmt_seg_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_crdt_lmt_seg_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_cl;
alter table ${iml_schema}.agt_crdt_lmt_seg_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_crdt_lmt_seg_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_op purge;
drop table ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_crdt_lmt_seg_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_crdt_lmt_seg_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
