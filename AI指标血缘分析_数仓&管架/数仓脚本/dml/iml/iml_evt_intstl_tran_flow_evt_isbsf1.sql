/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_intstl_tran_flow_evt_isbsf1
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
alter table ${iml_schema}.evt_intstl_tran_flow_evt add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_intstl_tran_flow_evt partition for ('isbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_tm purge;
drop table ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_op purge;
drop table ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,src_evt_id -- 源事件编号
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,rgst_teller_id -- 登记柜员编号
    ,tran_name -- 交易名称
    ,tran_id -- 交易编号
    ,bus_table_name -- 业务表名称
    ,bus_tab_flow_num -- 业务表流水号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,tran_cmplt_tm -- 交易完成时间
    ,remark -- 备注
    ,auth_status_cd -- 授权状态代码
    ,submit_status_cd -- 提交状态代码
    ,check_dt -- 复核日期
    ,auth_curr_cd -- 授权币种代码
    ,auth_amt -- 授权金额
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,modif_teller_id -- 修改柜员编号
    ,ord_tab_flow_num -- ORD表流水号
    ,org_id -- 机构编号
    ,entry_org_id -- 记账机构编号
    ,bus_belong_org_id -- 业务所属机构编号
    ,org_idf_cd -- 机构标识代码
    ,ova_flow_num -- 全局流水号
    ,revs_flow_num -- 冲正流水号
    ,revs_rs -- 冲正原因
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_intstl_tran_flow_evt partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_intstl_tran_flow_evt partition for ('isbsf1') where 0=1;

create table ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_intstl_tran_flow_evt partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_trn
insert into ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,src_evt_id -- 源事件编号
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,rgst_teller_id -- 登记柜员编号
    ,tran_name -- 交易名称
    ,tran_id -- 交易编号
    ,bus_table_name -- 业务表名称
    ,bus_tab_flow_num -- 业务表流水号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,tran_cmplt_tm -- 交易完成时间
    ,remark -- 备注
    ,auth_status_cd -- 授权状态代码
    ,submit_status_cd -- 提交状态代码
    ,check_dt -- 复核日期
    ,auth_curr_cd -- 授权币种代码
    ,auth_amt -- 授权金额
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,modif_teller_id -- 修改柜员编号
    ,ord_tab_flow_num -- ORD表流水号
    ,org_id -- 机构编号
    ,entry_org_id -- 记账机构编号
    ,bus_belong_org_id -- 业务所属机构编号
    ,org_idf_cd -- 机构标识代码
    ,ova_flow_num -- 全局流水号
    ,revs_flow_num -- 冲正流水号
    ,revs_rs -- 冲正原因
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104040'|| P1.INR -- 事件编号
    ,'9999' -- 法人编号
    ,P1.INR -- 源事件编号
    ,P1.INIDATTIM -- 交易时间
    ,P1.INIFRM -- 交易码
    ,P1.INIUSR -- 登记柜员编号
    ,P1.ININAM -- 交易名称
    ,P1.OWNREF -- 交易编号
    ,P1.OBJTYP -- 业务表名称
    ,P1.OBJINR -- 业务表流水号
    ,P1.OBJNAM -- 交易描述
    ,P1.USR -- 业务柜员编号
    ,P1.CPLDATTIM -- 交易完成时间
    ,P1.INFTXT -- 备注
    ,nvl(trim(P1.RELFLG),'-') -- 授权状态代码
    ,nvl(trim(P1.COMFLG),'U') -- 提交状态代码
    ,P1.COMDAT -- 复核日期
    ,nvl(trim（P1.RELCUR）,'-') -- 授权币种代码
    ,P1.RELAMT -- 授权金额
    ,nvl(trim（P1.RELORICUR）,'-') -- 币种代码
    ,P1.RELORIAMT -- 交易金额
    ,P1.RPRUSR -- 修改柜员编号
    ,P1.ORDINR -- ORD表流水号
    ,case when trim(P2.BRANCH) is not null then P2.BRANCH else P1.BCHKEYINR end -- 机构编号
    ,case when trim(P3.BRANCH) is not null then P3.BRANCH else P1.ACCBCHINR end -- 记账机构编号
    ,case when trim(P4.BRANCH) is not null then P4.BRANCH else P1.BRANCHINR end -- 业务所属机构编号
    ,nvl(trim(P1.ORGFLG),'-') -- 机构标识代码
    ,P1.QJLS -- 全局流水号
    ,P1.QJLSCZ -- 冲正流水号
    ,P1.CZREASON -- 冲正原因
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_trn' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_trn p1
    left join ${iol_schema}.isbs_bch p2 on P1.BCHKEYINR=p2.inr
and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bch p3 on P1.ACCBCHINR=p3.inr
and p3.start_dt <= to_date('${batch_date}','yyyymmdd') and p3.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bch p4 on P1.BRANCHINR=p4.inr
and p4.start_dt <= to_date('${batch_date}','yyyymmdd') and p4.end_dt > to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_tm 
  	                                group by 
  	                                        evt_id
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
        into ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,src_evt_id -- 源事件编号
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,rgst_teller_id -- 登记柜员编号
    ,tran_name -- 交易名称
    ,tran_id -- 交易编号
    ,bus_table_name -- 业务表名称
    ,bus_tab_flow_num -- 业务表流水号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,tran_cmplt_tm -- 交易完成时间
    ,remark -- 备注
    ,auth_status_cd -- 授权状态代码
    ,submit_status_cd -- 提交状态代码
    ,check_dt -- 复核日期
    ,auth_curr_cd -- 授权币种代码
    ,auth_amt -- 授权金额
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,modif_teller_id -- 修改柜员编号
    ,ord_tab_flow_num -- ORD表流水号
    ,org_id -- 机构编号
    ,entry_org_id -- 记账机构编号
    ,bus_belong_org_id -- 业务所属机构编号
    ,org_idf_cd -- 机构标识代码
    ,ova_flow_num -- 全局流水号
    ,revs_flow_num -- 冲正流水号
    ,revs_rs -- 冲正原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,src_evt_id -- 源事件编号
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,rgst_teller_id -- 登记柜员编号
    ,tran_name -- 交易名称
    ,tran_id -- 交易编号
    ,bus_table_name -- 业务表名称
    ,bus_tab_flow_num -- 业务表流水号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,tran_cmplt_tm -- 交易完成时间
    ,remark -- 备注
    ,auth_status_cd -- 授权状态代码
    ,submit_status_cd -- 提交状态代码
    ,check_dt -- 复核日期
    ,auth_curr_cd -- 授权币种代码
    ,auth_amt -- 授权金额
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,modif_teller_id -- 修改柜员编号
    ,ord_tab_flow_num -- ORD表流水号
    ,org_id -- 机构编号
    ,entry_org_id -- 记账机构编号
    ,bus_belong_org_id -- 业务所属机构编号
    ,org_idf_cd -- 机构标识代码
    ,ova_flow_num -- 全局流水号
    ,revs_flow_num -- 冲正流水号
    ,revs_rs -- 冲正原因
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
    ,nvl(n.src_evt_id, o.src_evt_id) as src_evt_id -- 源事件编号
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.tran_name, o.tran_name) as tran_name -- 交易名称
    ,nvl(n.tran_id, o.tran_id) as tran_id -- 交易编号
    ,nvl(n.bus_table_name, o.bus_table_name) as bus_table_name -- 业务表名称
    ,nvl(n.bus_tab_flow_num, o.bus_tab_flow_num) as bus_tab_flow_num -- 业务表流水号
    ,nvl(n.tran_descb, o.tran_descb) as tran_descb -- 交易描述
    ,nvl(n.bus_teller_id, o.bus_teller_id) as bus_teller_id -- 业务柜员编号
    ,nvl(n.tran_cmplt_tm, o.tran_cmplt_tm) as tran_cmplt_tm -- 交易完成时间
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.auth_status_cd, o.auth_status_cd) as auth_status_cd -- 授权状态代码
    ,nvl(n.submit_status_cd, o.submit_status_cd) as submit_status_cd -- 提交状态代码
    ,nvl(n.check_dt, o.check_dt) as check_dt -- 复核日期
    ,nvl(n.auth_curr_cd, o.auth_curr_cd) as auth_curr_cd -- 授权币种代码
    ,nvl(n.auth_amt, o.auth_amt) as auth_amt -- 授权金额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.modif_teller_id, o.modif_teller_id) as modif_teller_id -- 修改柜员编号
    ,nvl(n.ord_tab_flow_num, o.ord_tab_flow_num) as ord_tab_flow_num -- ORD表流水号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.entry_org_id, o.entry_org_id) as entry_org_id -- 记账机构编号
    ,nvl(n.bus_belong_org_id, o.bus_belong_org_id) as bus_belong_org_id -- 业务所属机构编号
    ,nvl(n.org_idf_cd, o.org_idf_cd) as org_idf_cd -- 机构标识代码
    ,nvl(n.ova_flow_num, o.ova_flow_num) as ova_flow_num -- 全局流水号
    ,nvl(n.revs_flow_num, o.revs_flow_num) as revs_flow_num -- 冲正流水号
    ,nvl(n.revs_rs, o.revs_rs) as revs_rs -- 冲正原因
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_tm n
    full join (select * from ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.src_evt_id <> n.src_evt_id
        or o.tran_tm <> n.tran_tm
        or o.tran_code <> n.tran_code
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.tran_name <> n.tran_name
        or o.tran_id <> n.tran_id
        or o.bus_table_name <> n.bus_table_name
        or o.bus_tab_flow_num <> n.bus_tab_flow_num
        or o.tran_descb <> n.tran_descb
        or o.bus_teller_id <> n.bus_teller_id
        or o.tran_cmplt_tm <> n.tran_cmplt_tm
        or o.remark <> n.remark
        or o.auth_status_cd <> n.auth_status_cd
        or o.submit_status_cd <> n.submit_status_cd
        or o.check_dt <> n.check_dt
        or o.auth_curr_cd <> n.auth_curr_cd
        or o.auth_amt <> n.auth_amt
        or o.curr_cd <> n.curr_cd
        or o.tran_amt <> n.tran_amt
        or o.modif_teller_id <> n.modif_teller_id
        or o.ord_tab_flow_num <> n.ord_tab_flow_num
        or o.org_id <> n.org_id
        or o.entry_org_id <> n.entry_org_id
        or o.bus_belong_org_id <> n.bus_belong_org_id
        or o.org_idf_cd <> n.org_idf_cd
        or o.ova_flow_num <> n.ova_flow_num
        or o.revs_flow_num <> n.revs_flow_num
        or o.revs_rs <> n.revs_rs
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,src_evt_id -- 源事件编号
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,rgst_teller_id -- 登记柜员编号
    ,tran_name -- 交易名称
    ,tran_id -- 交易编号
    ,bus_table_name -- 业务表名称
    ,bus_tab_flow_num -- 业务表流水号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,tran_cmplt_tm -- 交易完成时间
    ,remark -- 备注
    ,auth_status_cd -- 授权状态代码
    ,submit_status_cd -- 提交状态代码
    ,check_dt -- 复核日期
    ,auth_curr_cd -- 授权币种代码
    ,auth_amt -- 授权金额
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,modif_teller_id -- 修改柜员编号
    ,ord_tab_flow_num -- ORD表流水号
    ,org_id -- 机构编号
    ,entry_org_id -- 记账机构编号
    ,bus_belong_org_id -- 业务所属机构编号
    ,org_idf_cd -- 机构标识代码
    ,ova_flow_num -- 全局流水号
    ,revs_flow_num -- 冲正流水号
    ,revs_rs -- 冲正原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,src_evt_id -- 源事件编号
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,rgst_teller_id -- 登记柜员编号
    ,tran_name -- 交易名称
    ,tran_id -- 交易编号
    ,bus_table_name -- 业务表名称
    ,bus_tab_flow_num -- 业务表流水号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,tran_cmplt_tm -- 交易完成时间
    ,remark -- 备注
    ,auth_status_cd -- 授权状态代码
    ,submit_status_cd -- 提交状态代码
    ,check_dt -- 复核日期
    ,auth_curr_cd -- 授权币种代码
    ,auth_amt -- 授权金额
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,modif_teller_id -- 修改柜员编号
    ,ord_tab_flow_num -- ORD表流水号
    ,org_id -- 机构编号
    ,entry_org_id -- 记账机构编号
    ,bus_belong_org_id -- 业务所属机构编号
    ,org_idf_cd -- 机构标识代码
    ,ova_flow_num -- 全局流水号
    ,revs_flow_num -- 冲正流水号
    ,revs_rs -- 冲正原因
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
    ,o.src_evt_id -- 源事件编号
    ,o.tran_tm -- 交易时间
    ,o.tran_code -- 交易码
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.tran_name -- 交易名称
    ,o.tran_id -- 交易编号
    ,o.bus_table_name -- 业务表名称
    ,o.bus_tab_flow_num -- 业务表流水号
    ,o.tran_descb -- 交易描述
    ,o.bus_teller_id -- 业务柜员编号
    ,o.tran_cmplt_tm -- 交易完成时间
    ,o.remark -- 备注
    ,o.auth_status_cd -- 授权状态代码
    ,o.submit_status_cd -- 提交状态代码
    ,o.check_dt -- 复核日期
    ,o.auth_curr_cd -- 授权币种代码
    ,o.auth_amt -- 授权金额
    ,o.curr_cd -- 币种代码
    ,o.tran_amt -- 交易金额
    ,o.modif_teller_id -- 修改柜员编号
    ,o.ord_tab_flow_num -- ORD表流水号
    ,o.org_id -- 机构编号
    ,o.entry_org_id -- 记账机构编号
    ,o.bus_belong_org_id -- 业务所属机构编号
    ,o.org_idf_cd -- 机构标识代码
    ,o.ova_flow_num -- 全局流水号
    ,o.revs_flow_num -- 冲正流水号
    ,o.revs_rs -- 冲正原因
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
from ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_bk o
    left join ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_intstl_tran_flow_evt;
--alter table ${iml_schema}.evt_intstl_tran_flow_evt truncate partition for ('isbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_intstl_tran_flow_evt') 
               and substr(subpartition_name,1,8)=upper('p_isbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_intstl_tran_flow_evt drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_intstl_tran_flow_evt modify partition p_isbsf1 
add subpartition p_isbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_intstl_tran_flow_evt exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_cl;
alter table ${iml_schema}.evt_intstl_tran_flow_evt exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_intstl_tran_flow_evt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_tm purge;
drop table ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_op purge;
drop table ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_intstl_tran_flow_evt_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_intstl_tran_flow_evt', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
