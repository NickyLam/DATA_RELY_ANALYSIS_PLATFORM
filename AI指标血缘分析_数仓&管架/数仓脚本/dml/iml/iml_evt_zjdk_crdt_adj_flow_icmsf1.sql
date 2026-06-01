/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_zjdk_crdt_adj_flow_icmsf1
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
alter table ${iml_schema}.evt_zjdk_crdt_adj_flow add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_zjdk_crdt_adj_flow partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_tm purge;
drop table ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_op purge;
drop table ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_no -- 批次号
    ,crdt_id -- 授信编号
    ,crdt_chn_cd -- 授信渠道代码
    ,crdt_adj_type_cd -- 授信调整类型代码
    ,adj_flow_num -- 调整流水号
    ,bf_adj_crdt_pre_lmt -- 调整前授信预估额度
    ,bf_adj_crdt_day_int_rat -- 调整前授信日利率
    ,bf_adj_crdt_year_int_rat -- 调整前授信年利率
    ,a_adjust_crdt_pre_lmt -- 调整后授信预估额度
    ,a_adjust_crdt_day_int_rat -- 调整后授信日利率
    ,a_adjust_crdt_year_int_rat -- 调整后授信年利率
    ,plat_charatic_prod_data -- 平台特色产品数据
    ,req_id -- 请求编号
    ,apv_rest_cd -- 审批结果代码
    ,refuse_opinion -- 拒绝意见
    ,input_teller_id -- 录入柜员编号
    ,input_org_id -- 录入机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_zjdk_crdt_adj_flow partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_zjdk_crdt_adj_flow partition for ('icmsf1') where 0=1;

create table ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_zjdk_crdt_adj_flow partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_zjbk_adjuct_contract-1
insert into ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_no -- 批次号
    ,crdt_id -- 授信编号
    ,crdt_chn_cd -- 授信渠道代码
    ,crdt_adj_type_cd -- 授信调整类型代码
    ,adj_flow_num -- 调整流水号
    ,bf_adj_crdt_pre_lmt -- 调整前授信预估额度
    ,bf_adj_crdt_day_int_rat -- 调整前授信日利率
    ,bf_adj_crdt_year_int_rat -- 调整前授信年利率
    ,a_adjust_crdt_pre_lmt -- 调整后授信预估额度
    ,a_adjust_crdt_day_int_rat -- 调整后授信日利率
    ,a_adjust_crdt_year_int_rat -- 调整后授信年利率
    ,plat_charatic_prod_data -- 平台特色产品数据
    ,req_id -- 请求编号
    ,apv_rest_cd -- 审批结果代码
    ,refuse_opinion -- 拒绝意见
    ,input_teller_id -- 录入柜员编号
    ,input_org_id -- 录入机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401045'||P1.SERIALNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BATNUM -- 批次号
    ,P1.CRDTID -- 授信编号
    ,NVL(TRIM(P1.CRDTCHN),'-') -- 授信渠道代码
    ,NVL(TRIM(P1.CRDTADJTYP),'-') -- 授信调整类型代码
    ,P1.SERIALNO -- 调整流水号
    ,to_number(nvl(trim(P1.OLDCRDTESTIMATLMT),0))	 -- 	调整前授信预估额度
    ,to_number(nvl(trim(P1.OLDCRDTDAYRATE),0))	 -- 	调整前授信日利率
    ,to_number(nvl(trim(P1.OLDCRDTYEARRATE),0))	 -- 	调整前授信年利率
    ,to_number(nvl(trim(P1.NEWCRDTESTIMATLMT),0))	 -- 	调整后授信预估额度
    ,to_number(nvl(trim(P1.NEWCRDTDAYRATE),0))	 -- 	调整后授信日利率
    ,to_number(nvl(trim(P1.NEWCRDTYEARRATE),0))	 -- 	调整后授信年利率
    ,P1.PLATFSPECDATAPRD -- 平台特色产品数据
    ,P1.REQID -- 请求编号
    ,decode(P1.RSPOPINION,'PS','Finished','PR','Approving','RJ','Refused',' ','-',P1.RSPOPINION) -- 审批结果代码
    ,P1.REJECTREASON -- 拒绝意见
    ,P1.INPUTUSERID -- 录入柜员编号
    ,P1.INPUTORGID -- 录入机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_zjbk_adjuct_contract' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_zjbk_adjuct_contract p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,lp_id
  	                                        ,batch_no
  	                                        ,crdt_id
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
        into ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_no -- 批次号
    ,crdt_id -- 授信编号
    ,crdt_chn_cd -- 授信渠道代码
    ,crdt_adj_type_cd -- 授信调整类型代码
    ,adj_flow_num -- 调整流水号
    ,bf_adj_crdt_pre_lmt -- 调整前授信预估额度
    ,bf_adj_crdt_day_int_rat -- 调整前授信日利率
    ,bf_adj_crdt_year_int_rat -- 调整前授信年利率
    ,a_adjust_crdt_pre_lmt -- 调整后授信预估额度
    ,a_adjust_crdt_day_int_rat -- 调整后授信日利率
    ,a_adjust_crdt_year_int_rat -- 调整后授信年利率
    ,plat_charatic_prod_data -- 平台特色产品数据
    ,req_id -- 请求编号
    ,apv_rest_cd -- 审批结果代码
    ,refuse_opinion -- 拒绝意见
    ,input_teller_id -- 录入柜员编号
    ,input_org_id -- 录入机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_no -- 批次号
    ,crdt_id -- 授信编号
    ,crdt_chn_cd -- 授信渠道代码
    ,crdt_adj_type_cd -- 授信调整类型代码
    ,adj_flow_num -- 调整流水号
    ,bf_adj_crdt_pre_lmt -- 调整前授信预估额度
    ,bf_adj_crdt_day_int_rat -- 调整前授信日利率
    ,bf_adj_crdt_year_int_rat -- 调整前授信年利率
    ,a_adjust_crdt_pre_lmt -- 调整后授信预估额度
    ,a_adjust_crdt_day_int_rat -- 调整后授信日利率
    ,a_adjust_crdt_year_int_rat -- 调整后授信年利率
    ,plat_charatic_prod_data -- 平台特色产品数据
    ,req_id -- 请求编号
    ,apv_rest_cd -- 审批结果代码
    ,refuse_opinion -- 拒绝意见
    ,input_teller_id -- 录入柜员编号
    ,input_org_id -- 录入机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.crdt_id, o.crdt_id) as crdt_id -- 授信编号
    ,nvl(n.crdt_chn_cd, o.crdt_chn_cd) as crdt_chn_cd -- 授信渠道代码
    ,nvl(n.crdt_adj_type_cd, o.crdt_adj_type_cd) as crdt_adj_type_cd -- 授信调整类型代码
    ,nvl(n.adj_flow_num, o.adj_flow_num) as adj_flow_num -- 调整流水号
    ,nvl(n.bf_adj_crdt_pre_lmt, o.bf_adj_crdt_pre_lmt) as bf_adj_crdt_pre_lmt -- 调整前授信预估额度
    ,nvl(n.bf_adj_crdt_day_int_rat, o.bf_adj_crdt_day_int_rat) as bf_adj_crdt_day_int_rat -- 调整前授信日利率
    ,nvl(n.bf_adj_crdt_year_int_rat, o.bf_adj_crdt_year_int_rat) as bf_adj_crdt_year_int_rat -- 调整前授信年利率
    ,nvl(n.a_adjust_crdt_pre_lmt, o.a_adjust_crdt_pre_lmt) as a_adjust_crdt_pre_lmt -- 调整后授信预估额度
    ,nvl(n.a_adjust_crdt_day_int_rat, o.a_adjust_crdt_day_int_rat) as a_adjust_crdt_day_int_rat -- 调整后授信日利率
    ,nvl(n.a_adjust_crdt_year_int_rat, o.a_adjust_crdt_year_int_rat) as a_adjust_crdt_year_int_rat -- 调整后授信年利率
    ,nvl(n.plat_charatic_prod_data, o.plat_charatic_prod_data) as plat_charatic_prod_data -- 平台特色产品数据
    ,nvl(n.req_id, o.req_id) as req_id -- 请求编号
    ,nvl(n.apv_rest_cd, o.apv_rest_cd) as apv_rest_cd -- 审批结果代码
    ,nvl(n.refuse_opinion, o.refuse_opinion) as refuse_opinion -- 拒绝意见
    ,nvl(n.input_teller_id, o.input_teller_id) as input_teller_id -- 录入柜员编号
    ,nvl(n.input_org_id, o.input_org_id) as input_org_id -- 录入机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.final_update_teller_id, o.final_update_teller_id) as final_update_teller_id -- 最后更新柜员编号
    ,nvl(n.final_update_org_id, o.final_update_org_id) as final_update_org_id -- 最后更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.batch_no is null
            and n.crdt_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.batch_no is null
            and n.crdt_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.batch_no is null
            and n.crdt_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_tm n
    full join (select * from ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.batch_no = n.batch_no
            and o.crdt_id = n.crdt_id
where (
        o.evt_id is null
        and o.lp_id is null
        and o.batch_no is null
        and o.crdt_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
        and n.batch_no is null
        and n.crdt_id is null
    )
    or (
        o.crdt_chn_cd <> n.crdt_chn_cd
        or o.crdt_adj_type_cd <> n.crdt_adj_type_cd
        or o.adj_flow_num <> n.adj_flow_num
        or o.bf_adj_crdt_pre_lmt <> n.bf_adj_crdt_pre_lmt
        or o.bf_adj_crdt_day_int_rat <> n.bf_adj_crdt_day_int_rat
        or o.bf_adj_crdt_year_int_rat <> n.bf_adj_crdt_year_int_rat
        or o.a_adjust_crdt_pre_lmt <> n.a_adjust_crdt_pre_lmt
        or o.a_adjust_crdt_day_int_rat <> n.a_adjust_crdt_day_int_rat
        or o.a_adjust_crdt_year_int_rat <> n.a_adjust_crdt_year_int_rat
        or o.plat_charatic_prod_data <> n.plat_charatic_prod_data
        or o.req_id <> n.req_id
        or o.apv_rest_cd <> n.apv_rest_cd
        or o.refuse_opinion <> n.refuse_opinion
        or o.input_teller_id <> n.input_teller_id
        or o.input_org_id <> n.input_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.final_update_teller_id <> n.final_update_teller_id
        or o.final_update_org_id <> n.final_update_org_id
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_no -- 批次号
    ,crdt_id -- 授信编号
    ,crdt_chn_cd -- 授信渠道代码
    ,crdt_adj_type_cd -- 授信调整类型代码
    ,adj_flow_num -- 调整流水号
    ,bf_adj_crdt_pre_lmt -- 调整前授信预估额度
    ,bf_adj_crdt_day_int_rat -- 调整前授信日利率
    ,bf_adj_crdt_year_int_rat -- 调整前授信年利率
    ,a_adjust_crdt_pre_lmt -- 调整后授信预估额度
    ,a_adjust_crdt_day_int_rat -- 调整后授信日利率
    ,a_adjust_crdt_year_int_rat -- 调整后授信年利率
    ,plat_charatic_prod_data -- 平台特色产品数据
    ,req_id -- 请求编号
    ,apv_rest_cd -- 审批结果代码
    ,refuse_opinion -- 拒绝意见
    ,input_teller_id -- 录入柜员编号
    ,input_org_id -- 录入机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_no -- 批次号
    ,crdt_id -- 授信编号
    ,crdt_chn_cd -- 授信渠道代码
    ,crdt_adj_type_cd -- 授信调整类型代码
    ,adj_flow_num -- 调整流水号
    ,bf_adj_crdt_pre_lmt -- 调整前授信预估额度
    ,bf_adj_crdt_day_int_rat -- 调整前授信日利率
    ,bf_adj_crdt_year_int_rat -- 调整前授信年利率
    ,a_adjust_crdt_pre_lmt -- 调整后授信预估额度
    ,a_adjust_crdt_day_int_rat -- 调整后授信日利率
    ,a_adjust_crdt_year_int_rat -- 调整后授信年利率
    ,plat_charatic_prod_data -- 平台特色产品数据
    ,req_id -- 请求编号
    ,apv_rest_cd -- 审批结果代码
    ,refuse_opinion -- 拒绝意见
    ,input_teller_id -- 录入柜员编号
    ,input_org_id -- 录入机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.batch_no -- 批次号
    ,o.crdt_id -- 授信编号
    ,o.crdt_chn_cd -- 授信渠道代码
    ,o.crdt_adj_type_cd -- 授信调整类型代码
    ,o.adj_flow_num -- 调整流水号
    ,o.bf_adj_crdt_pre_lmt -- 调整前授信预估额度
    ,o.bf_adj_crdt_day_int_rat -- 调整前授信日利率
    ,o.bf_adj_crdt_year_int_rat -- 调整前授信年利率
    ,o.a_adjust_crdt_pre_lmt -- 调整后授信预估额度
    ,o.a_adjust_crdt_day_int_rat -- 调整后授信日利率
    ,o.a_adjust_crdt_year_int_rat -- 调整后授信年利率
    ,o.plat_charatic_prod_data -- 平台特色产品数据
    ,o.req_id -- 请求编号
    ,o.apv_rest_cd -- 审批结果代码
    ,o.refuse_opinion -- 拒绝意见
    ,o.input_teller_id -- 录入柜员编号
    ,o.input_org_id -- 录入机构编号
    ,o.rgst_dt -- 登记日期
    ,o.final_update_teller_id -- 最后更新柜员编号
    ,o.final_update_org_id -- 最后更新机构编号
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
from ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_bk o
    left join ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.batch_no = n.batch_no
            and o.crdt_id = n.crdt_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
            and o.batch_no = d.batch_no
            and o.crdt_id = d.crdt_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_zjdk_crdt_adj_flow;
--alter table ${iml_schema}.evt_zjdk_crdt_adj_flow truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_zjdk_crdt_adj_flow') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_zjdk_crdt_adj_flow drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_zjdk_crdt_adj_flow modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_zjdk_crdt_adj_flow exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_cl;
alter table ${iml_schema}.evt_zjdk_crdt_adj_flow exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_zjdk_crdt_adj_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_tm purge;
drop table ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_op purge;
drop table ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_zjdk_crdt_adj_flow_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_zjdk_crdt_adj_flow', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
