/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_epc_payfan_mercht_info_h_amssf1
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
alter table ${iml_schema}.agt_epc_payfan_mercht_info_h add partition p_amssf1 values ('amssf1')(
        subpartition p_amssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_amssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_epc_payfan_mercht_info_h partition for ('amssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_tm purge;
drop table ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_op purge;
drop table ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_status_cd -- 签约状态代码
    ,sign_dt -- 签约日期
    ,coll_acct_id -- 归集账户编号
    ,coll_acct_name -- 归集账户名称
    ,payfan_lmt -- 代付额度
    ,mercht_status_cd -- 商户状态代码
    ,cotas_name -- 联系人名称
    ,cotas_tel_num -- 联系人电话号码
    ,mgmt_chn_cd -- 管理渠道代码
    ,belong_brch_org_id -- 所属分行机构编号
    ,valid_flg -- 有效标志
    ,init_create_dt -- 最初创建日期
    ,create_teller_id -- 创建柜员编号
    ,create_teller_name -- 创建柜员名称
    ,latest_update_dt -- 最新更新日期
    ,update_teller_id -- 更新柜员编号
    ,update_teller_name -- 更新柜员名称
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_epc_payfan_mercht_info_h partition for ('amssf1')
where 0=1
;

create table ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_epc_payfan_mercht_info_h partition for ('amssf1') where 0=1;

create table ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_epc_payfan_mercht_info_h partition for ('amssf1') where 0=1;

-- 3.1 get new data into table
-- amss_online_pay_merchant-1
insert into ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_status_cd -- 签约状态代码
    ,sign_dt -- 签约日期
    ,coll_acct_id -- 归集账户编号
    ,coll_acct_name -- 归集账户名称
    ,payfan_lmt -- 代付额度
    ,mercht_status_cd -- 商户状态代码
    ,cotas_name -- 联系人名称
    ,cotas_tel_num -- 联系人电话号码
    ,mgmt_chn_cd -- 管理渠道代码
    ,belong_brch_org_id -- 所属分行机构编号
    ,valid_flg -- 有效标志
    ,init_create_dt -- 最初创建日期
    ,create_teller_id -- 创建柜员编号
    ,create_teller_name -- 创建柜员名称
    ,latest_update_dt -- 最新更新日期
    ,update_teller_id -- 更新柜员编号
    ,update_teller_name -- 更新柜员名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300067'||P1.SIGN_RCV_ACCT -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SIGN_NUM -- 序列号
    ,P1.SIGN_RCV_ACCT -- 签约账户编号
    ,P1.SIGN_RCV_ACCT_NAME -- 签约账户名称
    ,nvl(trim(P1.SIGN_RCV_ACCT_TYP),'-') -- 签约账户类型代码
    ,case when P1.SIGN_STATUS = '1' then 'C' else nvl(trim(P1.SIGN_STATUS),'-') end -- 签约状态代码
    ,P1.SIGN_TIME -- 签约日期
    ,P1.ACCT_NUM -- 归集账户编号
    ,P1.ACCT_NAME -- 归集账户名称
    ,P1.FUND_LMT -- 代付额度
    ,case when R1.TARGET_CD_VAL Is not null then R1.TARGET_CD_VAL else '@'||P1.MERCH_EXAMINE_STATUS end -- 商户状态代码
    ,P1.LNKM_NAME -- 联系人名称
    ,P1.LNKM_CEPH_NUM -- 联系人电话号码
    ,decode(P1.MGMT_PLATF_CHN,'1001','100001',' ','0000',P1.MGMT_PLATF_CHN) -- 管理渠道代码
    ,P1.ORG_ID -- 所属分行机构编号
    ,case when P1.PHYSICS_FLAG = 1 then '1' else '0' end -- 有效标志
    ,P1.CREATE_TIME -- 最初创建日期
    ,decode(to_char(P1.CREATE_USER),0,' ',to_char(P1.CREATE_USER)) -- 创建柜员编号
    ,P1.CREATE_EMP -- 创建柜员名称
    ,P1.UPDATE_TIME -- 最新更新日期
    ,decode(to_char(P1.CREATE_USER),0,' ',to_char(P1.UPDATE_USER)) -- 更新柜员编号
    ,P1.UPDATE_EMP -- 更新柜员名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'amss_online_pay_merchant' -- 源表名称
    ,'amssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.amss_online_pay_merchant p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.MERCH_EXAMINE_STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'AMSS'
        AND R1.SRC_TAB_EN_NAME= 'AMSS_ONLINE_PAY_MERCHANT'
        AND R1.SRC_FIELD_EN_NAME= 'MERCH_EXAMINE_STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_EPC_PAYFAN_MERCHT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'MERCHT_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,ser_num
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
        into ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_status_cd -- 签约状态代码
    ,sign_dt -- 签约日期
    ,coll_acct_id -- 归集账户编号
    ,coll_acct_name -- 归集账户名称
    ,payfan_lmt -- 代付额度
    ,mercht_status_cd -- 商户状态代码
    ,cotas_name -- 联系人名称
    ,cotas_tel_num -- 联系人电话号码
    ,mgmt_chn_cd -- 管理渠道代码
    ,belong_brch_org_id -- 所属分行机构编号
    ,valid_flg -- 有效标志
    ,init_create_dt -- 最初创建日期
    ,create_teller_id -- 创建柜员编号
    ,create_teller_name -- 创建柜员名称
    ,latest_update_dt -- 最新更新日期
    ,update_teller_id -- 更新柜员编号
    ,update_teller_name -- 更新柜员名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_status_cd -- 签约状态代码
    ,sign_dt -- 签约日期
    ,coll_acct_id -- 归集账户编号
    ,coll_acct_name -- 归集账户名称
    ,payfan_lmt -- 代付额度
    ,mercht_status_cd -- 商户状态代码
    ,cotas_name -- 联系人名称
    ,cotas_tel_num -- 联系人电话号码
    ,mgmt_chn_cd -- 管理渠道代码
    ,belong_brch_org_id -- 所属分行机构编号
    ,valid_flg -- 有效标志
    ,init_create_dt -- 最初创建日期
    ,create_teller_id -- 创建柜员编号
    ,create_teller_name -- 创建柜员名称
    ,latest_update_dt -- 最新更新日期
    ,update_teller_id -- 更新柜员编号
    ,update_teller_name -- 更新柜员名称
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
    ,nvl(n.ser_num, o.ser_num) as ser_num -- 序列号
    ,nvl(n.sign_acct_id, o.sign_acct_id) as sign_acct_id -- 签约账户编号
    ,nvl(n.sign_acct_name, o.sign_acct_name) as sign_acct_name -- 签约账户名称
    ,nvl(n.sign_acct_type_cd, o.sign_acct_type_cd) as sign_acct_type_cd -- 签约账户类型代码
    ,nvl(n.sign_status_cd, o.sign_status_cd) as sign_status_cd -- 签约状态代码
    ,nvl(n.sign_dt, o.sign_dt) as sign_dt -- 签约日期
    ,nvl(n.coll_acct_id, o.coll_acct_id) as coll_acct_id -- 归集账户编号
    ,nvl(n.coll_acct_name, o.coll_acct_name) as coll_acct_name -- 归集账户名称
    ,nvl(n.payfan_lmt, o.payfan_lmt) as payfan_lmt -- 代付额度
    ,nvl(n.mercht_status_cd, o.mercht_status_cd) as mercht_status_cd -- 商户状态代码
    ,nvl(n.cotas_name, o.cotas_name) as cotas_name -- 联系人名称
    ,nvl(n.cotas_tel_num, o.cotas_tel_num) as cotas_tel_num -- 联系人电话号码
    ,nvl(n.mgmt_chn_cd, o.mgmt_chn_cd) as mgmt_chn_cd -- 管理渠道代码
    ,nvl(n.belong_brch_org_id, o.belong_brch_org_id) as belong_brch_org_id -- 所属分行机构编号
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.init_create_dt, o.init_create_dt) as init_create_dt -- 最初创建日期
    ,nvl(n.create_teller_id, o.create_teller_id) as create_teller_id -- 创建柜员编号
    ,nvl(n.create_teller_name, o.create_teller_name) as create_teller_name -- 创建柜员名称
    ,nvl(n.latest_update_dt, o.latest_update_dt) as latest_update_dt -- 最新更新日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_teller_name, o.update_teller_name) as update_teller_name -- 更新柜员名称
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.ser_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.ser_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.ser_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_tm n
    full join (select * from ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.ser_num = n.ser_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.ser_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.ser_num is null
    )
    or (
        o.sign_acct_id <> n.sign_acct_id
        or o.sign_acct_name <> n.sign_acct_name
        or o.sign_acct_type_cd <> n.sign_acct_type_cd
        or o.sign_status_cd <> n.sign_status_cd
        or o.sign_dt <> n.sign_dt
        or o.coll_acct_id <> n.coll_acct_id
        or o.coll_acct_name <> n.coll_acct_name
        or o.payfan_lmt <> n.payfan_lmt
        or o.mercht_status_cd <> n.mercht_status_cd
        or o.cotas_name <> n.cotas_name
        or o.cotas_tel_num <> n.cotas_tel_num
        or o.mgmt_chn_cd <> n.mgmt_chn_cd
        or o.belong_brch_org_id <> n.belong_brch_org_id
        or o.valid_flg <> n.valid_flg
        or o.init_create_dt <> n.init_create_dt
        or o.create_teller_id <> n.create_teller_id
        or o.create_teller_name <> n.create_teller_name
        or o.latest_update_dt <> n.latest_update_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_teller_name <> n.update_teller_name
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_status_cd -- 签约状态代码
    ,sign_dt -- 签约日期
    ,coll_acct_id -- 归集账户编号
    ,coll_acct_name -- 归集账户名称
    ,payfan_lmt -- 代付额度
    ,mercht_status_cd -- 商户状态代码
    ,cotas_name -- 联系人名称
    ,cotas_tel_num -- 联系人电话号码
    ,mgmt_chn_cd -- 管理渠道代码
    ,belong_brch_org_id -- 所属分行机构编号
    ,valid_flg -- 有效标志
    ,init_create_dt -- 最初创建日期
    ,create_teller_id -- 创建柜员编号
    ,create_teller_name -- 创建柜员名称
    ,latest_update_dt -- 最新更新日期
    ,update_teller_id -- 更新柜员编号
    ,update_teller_name -- 更新柜员名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_status_cd -- 签约状态代码
    ,sign_dt -- 签约日期
    ,coll_acct_id -- 归集账户编号
    ,coll_acct_name -- 归集账户名称
    ,payfan_lmt -- 代付额度
    ,mercht_status_cd -- 商户状态代码
    ,cotas_name -- 联系人名称
    ,cotas_tel_num -- 联系人电话号码
    ,mgmt_chn_cd -- 管理渠道代码
    ,belong_brch_org_id -- 所属分行机构编号
    ,valid_flg -- 有效标志
    ,init_create_dt -- 最初创建日期
    ,create_teller_id -- 创建柜员编号
    ,create_teller_name -- 创建柜员名称
    ,latest_update_dt -- 最新更新日期
    ,update_teller_id -- 更新柜员编号
    ,update_teller_name -- 更新柜员名称
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
    ,o.ser_num -- 序列号
    ,o.sign_acct_id -- 签约账户编号
    ,o.sign_acct_name -- 签约账户名称
    ,o.sign_acct_type_cd -- 签约账户类型代码
    ,o.sign_status_cd -- 签约状态代码
    ,o.sign_dt -- 签约日期
    ,o.coll_acct_id -- 归集账户编号
    ,o.coll_acct_name -- 归集账户名称
    ,o.payfan_lmt -- 代付额度
    ,o.mercht_status_cd -- 商户状态代码
    ,o.cotas_name -- 联系人名称
    ,o.cotas_tel_num -- 联系人电话号码
    ,o.mgmt_chn_cd -- 管理渠道代码
    ,o.belong_brch_org_id -- 所属分行机构编号
    ,o.valid_flg -- 有效标志
    ,o.init_create_dt -- 最初创建日期
    ,o.create_teller_id -- 创建柜员编号
    ,o.create_teller_name -- 创建柜员名称
    ,o.latest_update_dt -- 最新更新日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_teller_name -- 更新柜员名称
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
from ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_bk o
    left join ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.ser_num = n.ser_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.ser_num = d.ser_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_epc_payfan_mercht_info_h;
--alter table ${iml_schema}.agt_epc_payfan_mercht_info_h truncate partition for ('amssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_epc_payfan_mercht_info_h') 
               and substr(subpartition_name,1,8)=upper('p_amssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_epc_payfan_mercht_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_epc_payfan_mercht_info_h modify partition p_amssf1 
add subpartition p_amssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_epc_payfan_mercht_info_h exchange subpartition p_amssf1_${batch_date} with table ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_cl;
alter table ${iml_schema}.agt_epc_payfan_mercht_info_h exchange subpartition p_amssf1_20991231 with table ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_epc_payfan_mercht_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_tm purge;
drop table ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_op purge;
drop table ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_epc_payfan_mercht_info_h_amssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_epc_payfan_mercht_info_h', partname => 'p_amssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
