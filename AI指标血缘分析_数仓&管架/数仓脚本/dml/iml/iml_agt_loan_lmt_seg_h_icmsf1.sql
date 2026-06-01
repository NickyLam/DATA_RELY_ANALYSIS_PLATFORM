/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_lmt_seg_h_icmsf1
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
alter table ${iml_schema}.agt_loan_lmt_seg_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_lmt_seg_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,seg_lmt_id -- 切分额度编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,up_level_seg_lmt_id -- 上层切分额度编号
    ,seg_obj_type_cd -- 切分对象类型代码
    ,seg_obj_id -- 切分对象编号
    ,circl_flg -- 循环标志
    ,curr_cd -- 币种代码
    ,tenor -- 期限
    ,nmal_amt -- 名义金额
    ,open_amt -- 敞口金额
    ,used_nmal_amt -- 已用敞口金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,higt_sig_amt -- 最高单笔金额
    ,lowt_margin_ratio -- 最低保证金比例
    ,lowt_int_rat -- 最低利率
    ,other_request_descb -- 其他要求描述
    ,status_cd -- 状态代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_dt -- 最后更新日期
    ,guar_type_cd -- 担保类型代码
    ,exlus_lmt_flg -- 专属额度标志
    ,chn_id -- 渠道编号
    ,init_obj_type_name -- 原对象类型名称
    ,init_obj_id -- 原对象编号
    ,lmt_belong_cust_id -- 额度所属客户编号
    ,comn_risk_open_lmt -- 一般风险敞口限额
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_lmt_seg_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_lmt_seg_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_lmt_seg_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_cl_divide-1
insert into ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_tm(
    agt_id -- 协议编号
    ,seg_lmt_id -- 切分额度编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,up_level_seg_lmt_id -- 上层切分额度编号
    ,seg_obj_type_cd -- 切分对象类型代码
    ,seg_obj_id -- 切分对象编号
    ,circl_flg -- 循环标志
    ,curr_cd -- 币种代码
    ,tenor -- 期限
    ,nmal_amt -- 名义金额
    ,open_amt -- 敞口金额
    ,used_nmal_amt -- 已用敞口金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,higt_sig_amt -- 最高单笔金额
    ,lowt_margin_ratio -- 最低保证金比例
    ,lowt_int_rat -- 最低利率
    ,other_request_descb -- 其他要求描述
    ,status_cd -- 状态代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_dt -- 最后更新日期
    ,guar_type_cd -- 担保类型代码
    ,exlus_lmt_flg -- 专属额度标志
    ,chn_id -- 渠道编号
    ,init_obj_type_name -- 原对象类型名称
    ,init_obj_id -- 原对象编号
    ,lmt_belong_cust_id -- 额度所属客户编号
    ,comn_risk_open_lmt -- 一般风险敞口限额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300007'||P1.SERIALNO -- 协议编号
    ,P1.SERIALNO -- 切分额度编号
    ,P1.OBJECTTYPE -- 对象类型名称
    ,P1.OBJECTNO -- 对象编号
    ,P1.PARENTSERIALNO -- 上层切分额度编号
    ,nvl(trim(P1.DIVIDEOBJECTTYPE),'-') -- 切分对象类型代码
    ,P1.DIVIDEOBJECTNO -- 切分对象编号
    ,nvl(trim(P1.CYCLEFLAG),'-') -- 循环标志
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.TERMMONTH -- 期限
    ,P1.NOMINALSUM -- 名义金额
    ,P1.EXPOSURESUM -- 敞口金额
    ,P1.OCCUPYNOMINALSUM -- 已用敞口金额
    ,P1.OCCUPYEXPOSURESUM -- 已用授信额度
    ,P1.AVAILABLENOMINALSUM -- 可用名义金额
    ,P1.AVAILABLEEXPOSURESUM -- 可用敞口金额
    ,P1.LOWRISKEXPOSURESUM -- 类低风险敞口金额
    ,P1.MAXBUSINESSSUM -- 最高单笔金额
    ,P1.MINBAILRATE -- 最低保证金比例
    ,P1.MINBUSINESSRATE -- 最低利率
    ,P1.OTHERCOMMAND -- 其他要求描述
    ,nvl(trim(P1.STATUS),'-') -- 状态代码
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEDATE -- 最后更新日期
    ,nvl(trim(P1.GUARANTYTYPE),'-') -- 担保类型代码
    ,P1.IFEXCLUSIVECREDIT -- 专属额度标志
    ,P1.CHANNEL -- 渠道编号
    ,P1.OLDOBJECTTYPE -- 原对象类型名称
    ,P1.OLDOBJECTNO -- 原对象编号
    ,P1.OWNERCUSTID -- 额度所属客户编号
    ,P1.RISKEXPOSURESUM -- 一般风险敞口限额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_cl_divide' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_cl_divide p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
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
        into ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_cl(
            agt_id -- 协议编号
    ,seg_lmt_id -- 切分额度编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,up_level_seg_lmt_id -- 上层切分额度编号
    ,seg_obj_type_cd -- 切分对象类型代码
    ,seg_obj_id -- 切分对象编号
    ,circl_flg -- 循环标志
    ,curr_cd -- 币种代码
    ,tenor -- 期限
    ,nmal_amt -- 名义金额
    ,open_amt -- 敞口金额
    ,used_nmal_amt -- 已用敞口金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,higt_sig_amt -- 最高单笔金额
    ,lowt_margin_ratio -- 最低保证金比例
    ,lowt_int_rat -- 最低利率
    ,other_request_descb -- 其他要求描述
    ,status_cd -- 状态代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_dt -- 最后更新日期
    ,guar_type_cd -- 担保类型代码
    ,exlus_lmt_flg -- 专属额度标志
    ,chn_id -- 渠道编号
    ,init_obj_type_name -- 原对象类型名称
    ,init_obj_id -- 原对象编号
    ,lmt_belong_cust_id -- 额度所属客户编号
    ,comn_risk_open_lmt -- 一般风险敞口限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_op(
            agt_id -- 协议编号
    ,seg_lmt_id -- 切分额度编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,up_level_seg_lmt_id -- 上层切分额度编号
    ,seg_obj_type_cd -- 切分对象类型代码
    ,seg_obj_id -- 切分对象编号
    ,circl_flg -- 循环标志
    ,curr_cd -- 币种代码
    ,tenor -- 期限
    ,nmal_amt -- 名义金额
    ,open_amt -- 敞口金额
    ,used_nmal_amt -- 已用敞口金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,higt_sig_amt -- 最高单笔金额
    ,lowt_margin_ratio -- 最低保证金比例
    ,lowt_int_rat -- 最低利率
    ,other_request_descb -- 其他要求描述
    ,status_cd -- 状态代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_dt -- 最后更新日期
    ,guar_type_cd -- 担保类型代码
    ,exlus_lmt_flg -- 专属额度标志
    ,chn_id -- 渠道编号
    ,init_obj_type_name -- 原对象类型名称
    ,init_obj_id -- 原对象编号
    ,lmt_belong_cust_id -- 额度所属客户编号
    ,comn_risk_open_lmt -- 一般风险敞口限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.seg_lmt_id, o.seg_lmt_id) as seg_lmt_id -- 切分额度编号
    ,nvl(n.obj_type_name, o.obj_type_name) as obj_type_name -- 对象类型名称
    ,nvl(n.obj_id, o.obj_id) as obj_id -- 对象编号
    ,nvl(n.up_level_seg_lmt_id, o.up_level_seg_lmt_id) as up_level_seg_lmt_id -- 上层切分额度编号
    ,nvl(n.seg_obj_type_cd, o.seg_obj_type_cd) as seg_obj_type_cd -- 切分对象类型代码
    ,nvl(n.seg_obj_id, o.seg_obj_id) as seg_obj_id -- 切分对象编号
    ,nvl(n.circl_flg, o.circl_flg) as circl_flg -- 循环标志
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tenor, o.tenor) as tenor -- 期限
    ,nvl(n.nmal_amt, o.nmal_amt) as nmal_amt -- 名义金额
    ,nvl(n.open_amt, o.open_amt) as open_amt -- 敞口金额
    ,nvl(n.used_nmal_amt, o.used_nmal_amt) as used_nmal_amt -- 已用敞口金额
    ,nvl(n.used_open_amt, o.used_open_amt) as used_open_amt -- 已用授信额度
    ,nvl(n.aval_nmal_amt, o.aval_nmal_amt) as aval_nmal_amt -- 可用名义金额
    ,nvl(n.aval_open_amt, o.aval_open_amt) as aval_open_amt -- 可用敞口金额
    ,nvl(n.class_low_risk_open_amt, o.class_low_risk_open_amt) as class_low_risk_open_amt -- 类低风险敞口金额
    ,nvl(n.higt_sig_amt, o.higt_sig_amt) as higt_sig_amt -- 最高单笔金额
    ,nvl(n.lowt_margin_ratio, o.lowt_margin_ratio) as lowt_margin_ratio -- 最低保证金比例
    ,nvl(n.lowt_int_rat, o.lowt_int_rat) as lowt_int_rat -- 最低利率
    ,nvl(n.other_request_descb, o.other_request_descb) as other_request_descb -- 其他要求描述
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,nvl(n.guar_type_cd, o.guar_type_cd) as guar_type_cd -- 担保类型代码
    ,nvl(n.exlus_lmt_flg, o.exlus_lmt_flg) as exlus_lmt_flg -- 专属额度标志
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.init_obj_type_name, o.init_obj_type_name) as init_obj_type_name -- 原对象类型名称
    ,nvl(n.init_obj_id, o.init_obj_id) as init_obj_id -- 原对象编号
    ,nvl(n.lmt_belong_cust_id, o.lmt_belong_cust_id) as lmt_belong_cust_id -- 额度所属客户编号
    ,nvl(n.comn_risk_open_lmt, o.comn_risk_open_lmt) as comn_risk_open_lmt -- 一般风险敞口限额
    ,case when
            n.agt_id is null
            and n.seg_lmt_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.seg_lmt_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.seg_lmt_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.seg_lmt_id = n.seg_lmt_id
where (
        o.agt_id is null
        and o.seg_lmt_id is null
    )
    or (
        n.agt_id is null
        and n.seg_lmt_id is null
    )
    or (
        o.obj_type_name <> n.obj_type_name
        or o.obj_id <> n.obj_id
        or o.up_level_seg_lmt_id <> n.up_level_seg_lmt_id
        or o.seg_obj_type_cd <> n.seg_obj_type_cd
        or o.seg_obj_id <> n.seg_obj_id
        or o.circl_flg <> n.circl_flg
        or o.curr_cd <> n.curr_cd
        or o.tenor <> n.tenor
        or o.nmal_amt <> n.nmal_amt
        or o.open_amt <> n.open_amt
        or o.used_nmal_amt <> n.used_nmal_amt
        or o.used_open_amt <> n.used_open_amt
        or o.aval_nmal_amt <> n.aval_nmal_amt
        or o.aval_open_amt <> n.aval_open_amt
        or o.class_low_risk_open_amt <> n.class_low_risk_open_amt
        or o.higt_sig_amt <> n.higt_sig_amt
        or o.lowt_margin_ratio <> n.lowt_margin_ratio
        or o.lowt_int_rat <> n.lowt_int_rat
        or o.other_request_descb <> n.other_request_descb
        or o.status_cd <> n.status_cd
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.final_update_dt <> n.final_update_dt
        or o.guar_type_cd <> n.guar_type_cd
        or o.exlus_lmt_flg <> n.exlus_lmt_flg
        or o.chn_id <> n.chn_id
        or o.init_obj_type_name <> n.init_obj_type_name
        or o.init_obj_id <> n.init_obj_id
        or o.lmt_belong_cust_id <> n.lmt_belong_cust_id
        or o.comn_risk_open_lmt <> n.comn_risk_open_lmt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_cl(
            agt_id -- 协议编号
    ,seg_lmt_id -- 切分额度编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,up_level_seg_lmt_id -- 上层切分额度编号
    ,seg_obj_type_cd -- 切分对象类型代码
    ,seg_obj_id -- 切分对象编号
    ,circl_flg -- 循环标志
    ,curr_cd -- 币种代码
    ,tenor -- 期限
    ,nmal_amt -- 名义金额
    ,open_amt -- 敞口金额
    ,used_nmal_amt -- 已用敞口金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,higt_sig_amt -- 最高单笔金额
    ,lowt_margin_ratio -- 最低保证金比例
    ,lowt_int_rat -- 最低利率
    ,other_request_descb -- 其他要求描述
    ,status_cd -- 状态代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_dt -- 最后更新日期
    ,guar_type_cd -- 担保类型代码
    ,exlus_lmt_flg -- 专属额度标志
    ,chn_id -- 渠道编号
    ,init_obj_type_name -- 原对象类型名称
    ,init_obj_id -- 原对象编号
    ,lmt_belong_cust_id -- 额度所属客户编号
    ,comn_risk_open_lmt -- 一般风险敞口限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_op(
            agt_id -- 协议编号
    ,seg_lmt_id -- 切分额度编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,up_level_seg_lmt_id -- 上层切分额度编号
    ,seg_obj_type_cd -- 切分对象类型代码
    ,seg_obj_id -- 切分对象编号
    ,circl_flg -- 循环标志
    ,curr_cd -- 币种代码
    ,tenor -- 期限
    ,nmal_amt -- 名义金额
    ,open_amt -- 敞口金额
    ,used_nmal_amt -- 已用敞口金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,higt_sig_amt -- 最高单笔金额
    ,lowt_margin_ratio -- 最低保证金比例
    ,lowt_int_rat -- 最低利率
    ,other_request_descb -- 其他要求描述
    ,status_cd -- 状态代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_dt -- 最后更新日期
    ,guar_type_cd -- 担保类型代码
    ,exlus_lmt_flg -- 专属额度标志
    ,chn_id -- 渠道编号
    ,init_obj_type_name -- 原对象类型名称
    ,init_obj_id -- 原对象编号
    ,lmt_belong_cust_id -- 额度所属客户编号
    ,comn_risk_open_lmt -- 一般风险敞口限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.seg_lmt_id -- 切分额度编号
    ,o.obj_type_name -- 对象类型名称
    ,o.obj_id -- 对象编号
    ,o.up_level_seg_lmt_id -- 上层切分额度编号
    ,o.seg_obj_type_cd -- 切分对象类型代码
    ,o.seg_obj_id -- 切分对象编号
    ,o.circl_flg -- 循环标志
    ,o.curr_cd -- 币种代码
    ,o.tenor -- 期限
    ,o.nmal_amt -- 名义金额
    ,o.open_amt -- 敞口金额
    ,o.used_nmal_amt -- 已用敞口金额
    ,o.used_open_amt -- 已用授信额度
    ,o.aval_nmal_amt -- 可用名义金额
    ,o.aval_open_amt -- 可用敞口金额
    ,o.class_low_risk_open_amt -- 类低风险敞口金额
    ,o.higt_sig_amt -- 最高单笔金额
    ,o.lowt_margin_ratio -- 最低保证金比例
    ,o.lowt_int_rat -- 最低利率
    ,o.other_request_descb -- 其他要求描述
    ,o.status_cd -- 状态代码
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.final_update_dt -- 最后更新日期
    ,o.guar_type_cd -- 担保类型代码
    ,o.exlus_lmt_flg -- 专属额度标志
    ,o.chn_id -- 渠道编号
    ,o.init_obj_type_name -- 原对象类型名称
    ,o.init_obj_id -- 原对象编号
    ,o.lmt_belong_cust_id -- 额度所属客户编号
    ,o.comn_risk_open_lmt -- 一般风险敞口限额
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
from ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.seg_lmt_id = n.seg_lmt_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.seg_lmt_id = d.seg_lmt_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_lmt_seg_h;
--alter table ${iml_schema}.agt_loan_lmt_seg_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_lmt_seg_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_lmt_seg_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_lmt_seg_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_lmt_seg_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_lmt_seg_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_lmt_seg_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_lmt_seg_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_lmt_seg_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
