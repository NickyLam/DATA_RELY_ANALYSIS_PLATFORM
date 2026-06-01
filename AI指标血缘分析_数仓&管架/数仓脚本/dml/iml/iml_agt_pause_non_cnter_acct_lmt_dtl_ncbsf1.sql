/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_pause_non_cnter_acct_lmt_dtl_ncbsf1
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
alter table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_tm purge;
drop table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_op purge;
drop table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_name -- 客户名称
    ,cust_acct_num -- 客户账号
    ,acct_status_cd -- 账户状态代码
    ,open_acct_dt -- 开户日期
    ,stl_acct_cls_cd -- 结算账户分类代码
    ,invalid_dt -- 失效日期
    ,effect_dt -- 生效日期
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,aldy_scan_flg -- 已被扫描标志
    ,term_rec_non_cnter_lmt_type_cd -- 暂记非柜面限制类型代码
    ,in_tab_rs -- 入表原因
    ,pause_non_cnter_cd -- 暂停非柜面代码
    ,sucs_flg -- 成功标志
    ,bus_batch_no -- 业务批次号
    ,list_src_cd -- 名单来源代码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,remark -- 备注
    ,remark_two -- 备注二
    ,open_acct_org_id -- 开户机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_uncounter_restraints-1
insert into ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_name -- 客户名称
    ,cust_acct_num -- 客户账号
    ,acct_status_cd -- 账户状态代码
    ,open_acct_dt -- 开户日期
    ,stl_acct_cls_cd -- 结算账户分类代码
    ,invalid_dt -- 失效日期
    ,effect_dt -- 生效日期
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,aldy_scan_flg -- 已被扫描标志
    ,term_rec_non_cnter_lmt_type_cd -- 暂记非柜面限制类型代码
    ,in_tab_rs -- 入表原因
    ,pause_non_cnter_cd -- 暂停非柜面代码
    ,sucs_flg -- 成功标志
    ,bus_batch_no -- 业务批次号
    ,list_src_cd -- 名单来源代码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,remark -- 备注
    ,remark_two -- 备注二
    ,open_acct_org_id -- 开户机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101069'||P1.UNCOUNTER_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.UNCOUNTER_NO -- 交易流水号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.DOCUMENT_ID -- 证件号码
    ,P1.DOCUMENT_TYPE -- 证件类型代码
    ,P1.CLIENT_NAME -- 客户名称
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.ACCT_STATUS -- 账户状态代码
    ,${iml_schema}.dateformat_max2(P1.ACCT_OPEN_DATE) -- 开户日期
    ,P1.SETTLE_ACCT_CLASS -- 结算账户分类代码
    ,${iml_schema}.dateformat_max2(P1.EXPIRE_DATE) -- 失效日期
    ,${iml_schema}.dateformat_max2(P1.EFFECT_DATE) -- 生效日期
    ,${iml_schema}.dateformat_max2(P1.UPDATE_DATE) -- 交易日期
    ,P1.INPUT_BRANCH -- 交易机构编号
    ,DECODE(P1.ISSCAN_FLAG,'Y','1','N','0') -- 已被扫描标志
    ,P1.UNCOUNTER_RESTRAINT_TYPE -- 暂记非柜面限制类型代码
    ,P1.UNCOUNTER_DESC -- 入表原因
    ,P1.UNCOUNTER_RESTRAINT_STATUS -- 暂停非柜面代码
    ,DECODE(P1.SUCCESS_FLAG,'Y','1','N','0') -- 成功标志
    ,P1.BATCH_NO -- 业务批次号
    ,P1.LIST_SOURCE -- 名单来源代码
    ,P1.OPER_USER_ID -- 交易柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.REMARK -- 备注
    ,p1.remark2 -- 备注二
    ,P1.OPEN_BRANCH -- 开户机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_uncounter_restraints' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_uncounter_restraints p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,tran_flow_num
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
        into ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_name -- 客户名称
    ,cust_acct_num -- 客户账号
    ,acct_status_cd -- 账户状态代码
    ,open_acct_dt -- 开户日期
    ,stl_acct_cls_cd -- 结算账户分类代码
    ,invalid_dt -- 失效日期
    ,effect_dt -- 生效日期
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,aldy_scan_flg -- 已被扫描标志
    ,term_rec_non_cnter_lmt_type_cd -- 暂记非柜面限制类型代码
    ,in_tab_rs -- 入表原因
    ,pause_non_cnter_cd -- 暂停非柜面代码
    ,sucs_flg -- 成功标志
    ,bus_batch_no -- 业务批次号
    ,list_src_cd -- 名单来源代码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,remark -- 备注
    ,remark_two -- 备注二
    ,open_acct_org_id -- 开户机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_name -- 客户名称
    ,cust_acct_num -- 客户账号
    ,acct_status_cd -- 账户状态代码
    ,open_acct_dt -- 开户日期
    ,stl_acct_cls_cd -- 结算账户分类代码
    ,invalid_dt -- 失效日期
    ,effect_dt -- 生效日期
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,aldy_scan_flg -- 已被扫描标志
    ,term_rec_non_cnter_lmt_type_cd -- 暂记非柜面限制类型代码
    ,in_tab_rs -- 入表原因
    ,pause_non_cnter_cd -- 暂停非柜面代码
    ,sucs_flg -- 成功标志
    ,bus_batch_no -- 业务批次号
    ,list_src_cd -- 名单来源代码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,remark -- 备注
    ,remark_two -- 备注二
    ,open_acct_org_id -- 开户机构编号
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
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.open_acct_dt, o.open_acct_dt) as open_acct_dt -- 开户日期
    ,nvl(n.stl_acct_cls_cd, o.stl_acct_cls_cd) as stl_acct_cls_cd -- 结算账户分类代码
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.aldy_scan_flg, o.aldy_scan_flg) as aldy_scan_flg -- 已被扫描标志
    ,nvl(n.term_rec_non_cnter_lmt_type_cd, o.term_rec_non_cnter_lmt_type_cd) as term_rec_non_cnter_lmt_type_cd -- 暂记非柜面限制类型代码
    ,nvl(n.in_tab_rs, o.in_tab_rs) as in_tab_rs -- 入表原因
    ,nvl(n.pause_non_cnter_cd, o.pause_non_cnter_cd) as pause_non_cnter_cd -- 暂停非柜面代码
    ,nvl(n.sucs_flg, o.sucs_flg) as sucs_flg -- 成功标志
    ,nvl(n.bus_batch_no, o.bus_batch_no) as bus_batch_no -- 业务批次号
    ,nvl(n.list_src_cd, o.list_src_cd) as list_src_cd -- 名单来源代码
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.remark_two, o.remark_two) as remark_two -- 备注二
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.tran_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.tran_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.tran_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.tran_flow_num = n.tran_flow_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.tran_flow_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.tran_flow_num is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.cert_no <> n.cert_no
        or o.cert_type_cd <> n.cert_type_cd
        or o.cust_name <> n.cust_name
        or o.cust_acct_num <> n.cust_acct_num
        or o.acct_status_cd <> n.acct_status_cd
        or o.open_acct_dt <> n.open_acct_dt
        or o.stl_acct_cls_cd <> n.stl_acct_cls_cd
        or o.invalid_dt <> n.invalid_dt
        or o.effect_dt <> n.effect_dt
        or o.tran_dt <> n.tran_dt
        or o.tran_org_id <> n.tran_org_id
        or o.aldy_scan_flg <> n.aldy_scan_flg
        or o.term_rec_non_cnter_lmt_type_cd <> n.term_rec_non_cnter_lmt_type_cd
        or o.in_tab_rs <> n.in_tab_rs
        or o.pause_non_cnter_cd <> n.pause_non_cnter_cd
        or o.sucs_flg <> n.sucs_flg
        or o.bus_batch_no <> n.bus_batch_no
        or o.list_src_cd <> n.list_src_cd
        or o.tran_teller_id <> n.tran_teller_id
        or o.tran_tm <> n.tran_tm
        or o.remark <> n.remark
        or o.remark_two <> n.remark_two
        or o.open_acct_org_id <> n.open_acct_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_name -- 客户名称
    ,cust_acct_num -- 客户账号
    ,acct_status_cd -- 账户状态代码
    ,open_acct_dt -- 开户日期
    ,stl_acct_cls_cd -- 结算账户分类代码
    ,invalid_dt -- 失效日期
    ,effect_dt -- 生效日期
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,aldy_scan_flg -- 已被扫描标志
    ,term_rec_non_cnter_lmt_type_cd -- 暂记非柜面限制类型代码
    ,in_tab_rs -- 入表原因
    ,pause_non_cnter_cd -- 暂停非柜面代码
    ,sucs_flg -- 成功标志
    ,bus_batch_no -- 业务批次号
    ,list_src_cd -- 名单来源代码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,remark -- 备注
    ,remark_two -- 备注二
    ,open_acct_org_id -- 开户机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_name -- 客户名称
    ,cust_acct_num -- 客户账号
    ,acct_status_cd -- 账户状态代码
    ,open_acct_dt -- 开户日期
    ,stl_acct_cls_cd -- 结算账户分类代码
    ,invalid_dt -- 失效日期
    ,effect_dt -- 生效日期
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,aldy_scan_flg -- 已被扫描标志
    ,term_rec_non_cnter_lmt_type_cd -- 暂记非柜面限制类型代码
    ,in_tab_rs -- 入表原因
    ,pause_non_cnter_cd -- 暂停非柜面代码
    ,sucs_flg -- 成功标志
    ,bus_batch_no -- 业务批次号
    ,list_src_cd -- 名单来源代码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,remark -- 备注
    ,remark_two -- 备注二
    ,open_acct_org_id -- 开户机构编号
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
    ,o.tran_flow_num -- 交易流水号
    ,o.cust_id -- 客户编号
    ,o.cert_no -- 证件号码
    ,o.cert_type_cd -- 证件类型代码
    ,o.cust_name -- 客户名称
    ,o.cust_acct_num -- 客户账号
    ,o.acct_status_cd -- 账户状态代码
    ,o.open_acct_dt -- 开户日期
    ,o.stl_acct_cls_cd -- 结算账户分类代码
    ,o.invalid_dt -- 失效日期
    ,o.effect_dt -- 生效日期
    ,o.tran_dt -- 交易日期
    ,o.tran_org_id -- 交易机构编号
    ,o.aldy_scan_flg -- 已被扫描标志
    ,o.term_rec_non_cnter_lmt_type_cd -- 暂记非柜面限制类型代码
    ,o.in_tab_rs -- 入表原因
    ,o.pause_non_cnter_cd -- 暂停非柜面代码
    ,o.sucs_flg -- 成功标志
    ,o.bus_batch_no -- 业务批次号
    ,o.list_src_cd -- 名单来源代码
    ,o.tran_teller_id -- 交易柜员编号
    ,o.tran_tm -- 交易时间
    ,o.remark -- 备注
    ,o.remark_two -- 备注二
    ,o.open_acct_org_id -- 开户机构编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_bk o
    left join ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.tran_flow_num = n.tran_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.tran_flow_num = d.tran_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl;
alter table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_cl;
alter table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_tm purge;
drop table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_op purge;
drop table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_pause_non_cnter_acct_lmt_dtl_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_pause_non_cnter_acct_lmt_dtl', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
