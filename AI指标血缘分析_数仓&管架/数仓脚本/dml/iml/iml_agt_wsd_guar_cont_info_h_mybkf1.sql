/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wsd_guar_cont_info_h_mybkf1
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
alter table ${iml_schema}.agt_wsd_guar_cont_info_h add partition p_mybkf1 values ('mybkf1')(
        subpartition p_mybkf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mybkf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wsd_guar_cont_info_h partition for ('mybkf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_tm purge;
drop table ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_op purge;
drop table ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_way_cd -- 担保方式代码
    ,guar_cont_status_cd -- 担保合同状态代码
    ,curr_cd -- 币种代码
    ,guar_amt -- 担保金额
    ,agt_sign_dt -- 协议签定日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,vouchee_cust_id -- 被担保人客户编号
    ,guartor_cust_id -- 担保人客户编号
    ,guartor_name -- 担保人名称
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_org_name -- 担保机构名称
    ,guar_item_promis_id -- 担保事项承诺书编号
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wsd_guar_cont_info_h partition for ('mybkf1')
where 0=1
;

create table ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wsd_guar_cont_info_h partition for ('mybkf1') where 0=1;

create table ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wsd_guar_cont_info_h partition for ('mybkf1') where 0=1;

-- 3.1 get new data into table
-- icms_mybk_guaranty_contract-1
insert into ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_way_cd -- 担保方式代码
    ,guar_cont_status_cd -- 担保合同状态代码
    ,curr_cd -- 币种代码
    ,guar_amt -- 担保金额
    ,agt_sign_dt -- 协议签定日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,vouchee_cust_id -- 被担保人客户编号
    ,guartor_cust_id -- 担保人客户编号
    ,guartor_name -- 担保人名称
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_org_name -- 担保机构名称
    ,guar_item_promis_id -- 担保事项承诺书编号
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300044'||P1.GUARANTYNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.GUARANTYNO -- 担保合同编号
    ,nvl(trim(P1.GUARANTYTYPE),'-') -- 担保合同类型代码
    ,nvl(trim(P1.GUARANTYSTYLE),'-') -- 担保方式代码
    ,nvl(trim(P1.GUARANTYSTATUS),'-') -- 担保合同状态代码
    ,nvl(trim(P1.GUARANTYCURRENCY),'-') -- 币种代码
    ,P1.USESUM -- 担保金额
    ,${iml_schema}.dateformat_min(P1.SIGNDATE) -- 协议签定日期
    ,${iml_schema}.dateformat_min(P1.BEGINDATE) -- 生效日期
    ,${iml_schema}.dateformat_max2(P1.ENDDATE) -- 失效日期
    ,P1.CUSTOMERID -- 被担保人客户编号
    ,P1.GUARANTORID -- 担保人客户编号
    ,P1.GUARANTORNAME -- 担保人名称
    ,P1.CERTTYPE -- 担保人证件类型代码
    ,P1.CERTID -- 担保人证件号码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.GUARANTEEFORM END -- 保证担保形式代码
    ,P1.GUAORGNAME -- 担保机构名称
    ,P1.GUAPROMISEBOOKID -- 担保事项承诺书编号
    ,nvl(trim(P1.ISGUARANTYPLATFORMLOAN),'-') -- 政府性融资担保公司保证标志
    ,nvl(trim(P1.ISBACKGUARANTY),'-') -- 反担保标志
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTDATE -- 登记日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_mybk_guaranty_contract' -- 源表名称
    ,'mybkf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_mybk_guaranty_contract p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.GUARANTEEFORM = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_MYBK_GUARANTY_CONTRACT'
        AND R1.SRC_FIELD_EN_NAME= 'GUARANTEEFORM'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_WSD_GUAR_CONT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'GUAR_GUAR_FORM_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_tm 
  	                                group by 
  	                                        agt_id
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
        into ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_way_cd -- 担保方式代码
    ,guar_cont_status_cd -- 担保合同状态代码
    ,curr_cd -- 币种代码
    ,guar_amt -- 担保金额
    ,agt_sign_dt -- 协议签定日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,vouchee_cust_id -- 被担保人客户编号
    ,guartor_cust_id -- 担保人客户编号
    ,guartor_name -- 担保人名称
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_org_name -- 担保机构名称
    ,guar_item_promis_id -- 担保事项承诺书编号
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_way_cd -- 担保方式代码
    ,guar_cont_status_cd -- 担保合同状态代码
    ,curr_cd -- 币种代码
    ,guar_amt -- 担保金额
    ,agt_sign_dt -- 协议签定日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,vouchee_cust_id -- 被担保人客户编号
    ,guartor_cust_id -- 担保人客户编号
    ,guartor_name -- 担保人名称
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_org_name -- 担保机构名称
    ,guar_item_promis_id -- 担保事项承诺书编号
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
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
    ,nvl(n.guar_cont_id, o.guar_cont_id) as guar_cont_id -- 担保合同编号
    ,nvl(n.guar_cont_type_cd, o.guar_cont_type_cd) as guar_cont_type_cd -- 担保合同类型代码
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 担保方式代码
    ,nvl(n.guar_cont_status_cd, o.guar_cont_status_cd) as guar_cont_status_cd -- 担保合同状态代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.guar_amt, o.guar_amt) as guar_amt -- 担保金额
    ,nvl(n.agt_sign_dt, o.agt_sign_dt) as agt_sign_dt -- 协议签定日期
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.vouchee_cust_id, o.vouchee_cust_id) as vouchee_cust_id -- 被担保人客户编号
    ,nvl(n.guartor_cust_id, o.guartor_cust_id) as guartor_cust_id -- 担保人客户编号
    ,nvl(n.guartor_name, o.guartor_name) as guartor_name -- 担保人名称
    ,nvl(n.guartor_cert_type_cd, o.guartor_cert_type_cd) as guartor_cert_type_cd -- 担保人证件类型代码
    ,nvl(n.guartor_cert_no, o.guartor_cert_no) as guartor_cert_no -- 担保人证件号码
    ,nvl(n.guar_guar_form_cd, o.guar_guar_form_cd) as guar_guar_form_cd -- 保证担保形式代码
    ,nvl(n.guar_org_name, o.guar_org_name) as guar_org_name -- 担保机构名称
    ,nvl(n.guar_item_promis_id, o.guar_item_promis_id) as guar_item_promis_id -- 担保事项承诺书编号
    ,nvl(n.gover_fin_guar_corp_guar_flg, o.gover_fin_guar_corp_guar_flg) as gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,nvl(n.rev_guar_flg, o.rev_guar_flg) as rev_guar_flg -- 反担保标志
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_tm n
    full join (select * from ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.guar_cont_id <> n.guar_cont_id
        or o.guar_cont_type_cd <> n.guar_cont_type_cd
        or o.guar_way_cd <> n.guar_way_cd
        or o.guar_cont_status_cd <> n.guar_cont_status_cd
        or o.curr_cd <> n.curr_cd
        or o.guar_amt <> n.guar_amt
        or o.agt_sign_dt <> n.agt_sign_dt
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.vouchee_cust_id <> n.vouchee_cust_id
        or o.guartor_cust_id <> n.guartor_cust_id
        or o.guartor_name <> n.guartor_name
        or o.guartor_cert_type_cd <> n.guartor_cert_type_cd
        or o.guartor_cert_no <> n.guartor_cert_no
        or o.guar_guar_form_cd <> n.guar_guar_form_cd
        or o.guar_org_name <> n.guar_org_name
        or o.guar_item_promis_id <> n.guar_item_promis_id
        or o.gover_fin_guar_corp_guar_flg <> n.gover_fin_guar_corp_guar_flg
        or o.rev_guar_flg <> n.rev_guar_flg
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_dt <> n.rgst_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_way_cd -- 担保方式代码
    ,guar_cont_status_cd -- 担保合同状态代码
    ,curr_cd -- 币种代码
    ,guar_amt -- 担保金额
    ,agt_sign_dt -- 协议签定日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,vouchee_cust_id -- 被担保人客户编号
    ,guartor_cust_id -- 担保人客户编号
    ,guartor_name -- 担保人名称
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_org_name -- 担保机构名称
    ,guar_item_promis_id -- 担保事项承诺书编号
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_way_cd -- 担保方式代码
    ,guar_cont_status_cd -- 担保合同状态代码
    ,curr_cd -- 币种代码
    ,guar_amt -- 担保金额
    ,agt_sign_dt -- 协议签定日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,vouchee_cust_id -- 被担保人客户编号
    ,guartor_cust_id -- 担保人客户编号
    ,guartor_name -- 担保人名称
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_org_name -- 担保机构名称
    ,guar_item_promis_id -- 担保事项承诺书编号
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
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
    ,o.guar_cont_id -- 担保合同编号
    ,o.guar_cont_type_cd -- 担保合同类型代码
    ,o.guar_way_cd -- 担保方式代码
    ,o.guar_cont_status_cd -- 担保合同状态代码
    ,o.curr_cd -- 币种代码
    ,o.guar_amt -- 担保金额
    ,o.agt_sign_dt -- 协议签定日期
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.vouchee_cust_id -- 被担保人客户编号
    ,o.guartor_cust_id -- 担保人客户编号
    ,o.guartor_name -- 担保人名称
    ,o.guartor_cert_type_cd -- 担保人证件类型代码
    ,o.guartor_cert_no -- 担保人证件号码
    ,o.guar_guar_form_cd -- 保证担保形式代码
    ,o.guar_org_name -- 担保机构名称
    ,o.guar_item_promis_id -- 担保事项承诺书编号
    ,o.gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,o.rev_guar_flg -- 反担保标志
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_dt -- 登记日期
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
from ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_bk o
    left join ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_wsd_guar_cont_info_h;
--alter table ${iml_schema}.agt_wsd_guar_cont_info_h truncate partition for ('mybkf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_wsd_guar_cont_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mybkf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_wsd_guar_cont_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_wsd_guar_cont_info_h modify partition p_mybkf1 
add subpartition p_mybkf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_wsd_guar_cont_info_h exchange subpartition p_mybkf1_${batch_date} with table ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_cl;
alter table ${iml_schema}.agt_wsd_guar_cont_info_h exchange subpartition p_mybkf1_20991231 with table ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wsd_guar_cont_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_tm purge;
drop table ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_op purge;
drop table ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_wsd_guar_cont_info_h_mybkf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wsd_guar_cont_info_h', partname => 'p_mybkf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
