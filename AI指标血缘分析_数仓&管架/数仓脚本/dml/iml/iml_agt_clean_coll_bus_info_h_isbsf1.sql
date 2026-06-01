/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_clean_coll_bus_info_h_isbsf1
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
alter table ${iml_schema}.agt_clean_coll_bus_info_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_clean_coll_bus_info_h partition for ('isbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_op purge;
drop table ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,clean_coll_bus_id -- 光票托收业务编号
    ,bus_id -- 业务编号
    ,tran_name -- 交易名称
    ,draw_dt -- 出票日期
    ,create_date -- 创建日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,recvbl_dt -- 收款日期
    ,dsply_info_flg -- 显示信息标志
    ,clean_coll_form_cd -- 光票托收形式代码
    ,pay_way_cd -- 付款方式代码
    ,stl_way_cd -- 结算方式代码
    ,bill_type_cd -- 票据类型代码
    ,vrfction_slip_id -- 核销单编号
    ,decl_form_id -- 申报单编号
    ,cust_type_cd -- 客户类型代码
    ,free_pay_flg -- 自由付款标志
    ,nra_pay_flg -- NRA付款标志
    ,pkg_coll_bus_id -- 打包托收业务编号
    ,pkg_coll_recvbl_dt -- 打包托收收款日期
    ,oper_teller_id -- 经办柜员编号
    ,bus_oper_org_id -- 业务经办机构编号
    ,bus_belong_org_id -- 业务所属机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_clean_coll_bus_info_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_clean_coll_bus_info_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_clean_coll_bus_info_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_ccd-1
insert into ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,clean_coll_bus_id -- 光票托收业务编号
    ,bus_id -- 业务编号
    ,tran_name -- 交易名称
    ,draw_dt -- 出票日期
    ,create_date -- 创建日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,recvbl_dt -- 收款日期
    ,dsply_info_flg -- 显示信息标志
    ,clean_coll_form_cd -- 光票托收形式代码
    ,pay_way_cd -- 付款方式代码
    ,stl_way_cd -- 结算方式代码
    ,bill_type_cd -- 票据类型代码
    ,vrfction_slip_id -- 核销单编号
    ,decl_form_id -- 申报单编号
    ,cust_type_cd -- 客户类型代码
    ,free_pay_flg -- 自由付款标志
    ,nra_pay_flg -- NRA付款标志
    ,pkg_coll_bus_id -- 打包托收业务编号
    ,pkg_coll_recvbl_dt -- 打包托收收款日期
    ,oper_teller_id -- 经办柜员编号
    ,bus_oper_org_id -- 业务经办机构编号
    ,bus_belong_org_id -- 业务所属机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300051'||P1.INR -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INR -- 光票托收业务编号
    ,P1.OWNREF -- 业务编号
    ,P1.NAM -- 交易名称
    ,P1.CHKDAT -- 出票日期
    ,P1.CREDAT -- 创建日期
    ,P1.OPNDAT -- 生效日期
    ,P1.CLSDAT -- 失效日期
    ,P1.PAYDAT -- 收款日期
    ,decode(trim(P1.INFDSP),'X','1','','0',P1.INFDSP) -- 显示信息标志
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.CCFORM END -- 光票托收形式代码
    ,nvl(trim(P1.PURFLG),'-') -- 付款方式代码
    ,nvl(trim(P1.MODSET),'-') -- 结算方式代码
    ,nvl(trim(P1.TOCSEL),'-') -- 票据类型代码
    ,P1.VERCERREF -- 核销单编号
    ,P1.DECNUM -- 申报单编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'|| P1.PRETYP END -- 客户类型代码
    ,decode(trim(P1.FREPAYFLG),'X','1','','0',P1.FREPAYFLG) -- 自由付款标志
    ,decode(trim(P1.NRAFLG),'Y','1','N','0','','-',P1.NRAFLG) -- NRA付款标志
    ,P1.RPTBTCHNO -- 打包托收业务编号
    ,P1.PRODAT -- 打包托收收款日期
    ,P1.OWNUSR -- 经办柜员编号
    ,nvl(trim(P2.BCHKEY),' ') -- 业务经办机构编号
    ,nvl(trim(P2.BRANCH),' ') -- 业务所属机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_ccd' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_ccd p1
    left join ${iol_schema}.isbs_bch p2 on  P1.BRANCHINR = P2.INR
    AND p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CCFORM = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ISBS'
        AND R1.SRC_TAB_EN_NAME= 'ISBS_CCD'
        AND R1.SRC_FIELD_EN_NAME= 'CCFORM'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_CLEAN_COLL_BUS_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CLEAN_COLL_FORM_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PRETYP = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ISBS'
        AND R2.SRC_TAB_EN_NAME= 'ISBS_CCD'
        AND R2.SRC_FIELD_EN_NAME= 'PRETYP'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_CLEAN_COLL_BUS_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_tm 
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
        into ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,clean_coll_bus_id -- 光票托收业务编号
    ,bus_id -- 业务编号
    ,tran_name -- 交易名称
    ,draw_dt -- 出票日期
    ,create_date -- 创建日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,recvbl_dt -- 收款日期
    ,dsply_info_flg -- 显示信息标志
    ,clean_coll_form_cd -- 光票托收形式代码
    ,pay_way_cd -- 付款方式代码
    ,stl_way_cd -- 结算方式代码
    ,bill_type_cd -- 票据类型代码
    ,vrfction_slip_id -- 核销单编号
    ,decl_form_id -- 申报单编号
    ,cust_type_cd -- 客户类型代码
    ,free_pay_flg -- 自由付款标志
    ,nra_pay_flg -- NRA付款标志
    ,pkg_coll_bus_id -- 打包托收业务编号
    ,pkg_coll_recvbl_dt -- 打包托收收款日期
    ,oper_teller_id -- 经办柜员编号
    ,bus_oper_org_id -- 业务经办机构编号
    ,bus_belong_org_id -- 业务所属机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,clean_coll_bus_id -- 光票托收业务编号
    ,bus_id -- 业务编号
    ,tran_name -- 交易名称
    ,draw_dt -- 出票日期
    ,create_date -- 创建日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,recvbl_dt -- 收款日期
    ,dsply_info_flg -- 显示信息标志
    ,clean_coll_form_cd -- 光票托收形式代码
    ,pay_way_cd -- 付款方式代码
    ,stl_way_cd -- 结算方式代码
    ,bill_type_cd -- 票据类型代码
    ,vrfction_slip_id -- 核销单编号
    ,decl_form_id -- 申报单编号
    ,cust_type_cd -- 客户类型代码
    ,free_pay_flg -- 自由付款标志
    ,nra_pay_flg -- NRA付款标志
    ,pkg_coll_bus_id -- 打包托收业务编号
    ,pkg_coll_recvbl_dt -- 打包托收收款日期
    ,oper_teller_id -- 经办柜员编号
    ,bus_oper_org_id -- 业务经办机构编号
    ,bus_belong_org_id -- 业务所属机构编号
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
    ,nvl(n.clean_coll_bus_id, o.clean_coll_bus_id) as clean_coll_bus_id -- 光票托收业务编号
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.tran_name, o.tran_name) as tran_name -- 交易名称
    ,nvl(n.draw_dt, o.draw_dt) as draw_dt -- 出票日期
    ,nvl(n.create_date, o.create_date) as create_date -- 创建日期
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.recvbl_dt, o.recvbl_dt) as recvbl_dt -- 收款日期
    ,nvl(n.dsply_info_flg, o.dsply_info_flg) as dsply_info_flg -- 显示信息标志
    ,nvl(n.clean_coll_form_cd, o.clean_coll_form_cd) as clean_coll_form_cd -- 光票托收形式代码
    ,nvl(n.pay_way_cd, o.pay_way_cd) as pay_way_cd -- 付款方式代码
    ,nvl(n.stl_way_cd, o.stl_way_cd) as stl_way_cd -- 结算方式代码
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.vrfction_slip_id, o.vrfction_slip_id) as vrfction_slip_id -- 核销单编号
    ,nvl(n.decl_form_id, o.decl_form_id) as decl_form_id -- 申报单编号
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.free_pay_flg, o.free_pay_flg) as free_pay_flg -- 自由付款标志
    ,nvl(n.nra_pay_flg, o.nra_pay_flg) as nra_pay_flg -- NRA付款标志
    ,nvl(n.pkg_coll_bus_id, o.pkg_coll_bus_id) as pkg_coll_bus_id -- 打包托收业务编号
    ,nvl(n.pkg_coll_recvbl_dt, o.pkg_coll_recvbl_dt) as pkg_coll_recvbl_dt -- 打包托收收款日期
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 经办柜员编号
    ,nvl(n.bus_oper_org_id, o.bus_oper_org_id) as bus_oper_org_id -- 业务经办机构编号
    ,nvl(n.bus_belong_org_id, o.bus_belong_org_id) as bus_belong_org_id -- 业务所属机构编号
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
from ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_tm n
    full join (select * from ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.clean_coll_bus_id <> n.clean_coll_bus_id
        or o.bus_id <> n.bus_id
        or o.tran_name <> n.tran_name
        or o.draw_dt <> n.draw_dt
        or o.create_date <> n.create_date
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.recvbl_dt <> n.recvbl_dt
        or o.dsply_info_flg <> n.dsply_info_flg
        or o.clean_coll_form_cd <> n.clean_coll_form_cd
        or o.pay_way_cd <> n.pay_way_cd
        or o.stl_way_cd <> n.stl_way_cd
        or o.bill_type_cd <> n.bill_type_cd
        or o.vrfction_slip_id <> n.vrfction_slip_id
        or o.decl_form_id <> n.decl_form_id
        or o.cust_type_cd <> n.cust_type_cd
        or o.free_pay_flg <> n.free_pay_flg
        or o.nra_pay_flg <> n.nra_pay_flg
        or o.pkg_coll_bus_id <> n.pkg_coll_bus_id
        or o.pkg_coll_recvbl_dt <> n.pkg_coll_recvbl_dt
        or o.oper_teller_id <> n.oper_teller_id
        or o.bus_oper_org_id <> n.bus_oper_org_id
        or o.bus_belong_org_id <> n.bus_belong_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,clean_coll_bus_id -- 光票托收业务编号
    ,bus_id -- 业务编号
    ,tran_name -- 交易名称
    ,draw_dt -- 出票日期
    ,create_date -- 创建日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,recvbl_dt -- 收款日期
    ,dsply_info_flg -- 显示信息标志
    ,clean_coll_form_cd -- 光票托收形式代码
    ,pay_way_cd -- 付款方式代码
    ,stl_way_cd -- 结算方式代码
    ,bill_type_cd -- 票据类型代码
    ,vrfction_slip_id -- 核销单编号
    ,decl_form_id -- 申报单编号
    ,cust_type_cd -- 客户类型代码
    ,free_pay_flg -- 自由付款标志
    ,nra_pay_flg -- NRA付款标志
    ,pkg_coll_bus_id -- 打包托收业务编号
    ,pkg_coll_recvbl_dt -- 打包托收收款日期
    ,oper_teller_id -- 经办柜员编号
    ,bus_oper_org_id -- 业务经办机构编号
    ,bus_belong_org_id -- 业务所属机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,clean_coll_bus_id -- 光票托收业务编号
    ,bus_id -- 业务编号
    ,tran_name -- 交易名称
    ,draw_dt -- 出票日期
    ,create_date -- 创建日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,recvbl_dt -- 收款日期
    ,dsply_info_flg -- 显示信息标志
    ,clean_coll_form_cd -- 光票托收形式代码
    ,pay_way_cd -- 付款方式代码
    ,stl_way_cd -- 结算方式代码
    ,bill_type_cd -- 票据类型代码
    ,vrfction_slip_id -- 核销单编号
    ,decl_form_id -- 申报单编号
    ,cust_type_cd -- 客户类型代码
    ,free_pay_flg -- 自由付款标志
    ,nra_pay_flg -- NRA付款标志
    ,pkg_coll_bus_id -- 打包托收业务编号
    ,pkg_coll_recvbl_dt -- 打包托收收款日期
    ,oper_teller_id -- 经办柜员编号
    ,bus_oper_org_id -- 业务经办机构编号
    ,bus_belong_org_id -- 业务所属机构编号
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
    ,o.clean_coll_bus_id -- 光票托收业务编号
    ,o.bus_id -- 业务编号
    ,o.tran_name -- 交易名称
    ,o.draw_dt -- 出票日期
    ,o.create_date -- 创建日期
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.recvbl_dt -- 收款日期
    ,o.dsply_info_flg -- 显示信息标志
    ,o.clean_coll_form_cd -- 光票托收形式代码
    ,o.pay_way_cd -- 付款方式代码
    ,o.stl_way_cd -- 结算方式代码
    ,o.bill_type_cd -- 票据类型代码
    ,o.vrfction_slip_id -- 核销单编号
    ,o.decl_form_id -- 申报单编号
    ,o.cust_type_cd -- 客户类型代码
    ,o.free_pay_flg -- 自由付款标志
    ,o.nra_pay_flg -- NRA付款标志
    ,o.pkg_coll_bus_id -- 打包托收业务编号
    ,o.pkg_coll_recvbl_dt -- 打包托收收款日期
    ,o.oper_teller_id -- 经办柜员编号
    ,o.bus_oper_org_id -- 业务经办机构编号
    ,o.bus_belong_org_id -- 业务所属机构编号
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
from ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_bk o
    left join ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_cl d
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
--truncate table ${iml_schema}.agt_clean_coll_bus_info_h;
--alter table ${iml_schema}.agt_clean_coll_bus_info_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_clean_coll_bus_info_h') 
               and substr(subpartition_name,1,8)=upper('p_isbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_clean_coll_bus_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_clean_coll_bus_info_h modify partition p_isbsf1 
add subpartition p_isbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_clean_coll_bus_info_h exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_cl;
alter table ${iml_schema}.agt_clean_coll_bus_info_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_clean_coll_bus_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_op purge;
drop table ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_clean_coll_bus_info_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_clean_coll_bus_info_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
