/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_chn_equip_info_h_nibsf1
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
alter table ${iml_schema}.chn_equip_info_h add partition p_nibsf1 values ('nibsf1')(
        subpartition p_nibsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_nibsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.chn_equip_info_h_nibsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.chn_equip_info_h partition for ('nibsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.chn_equip_info_h_nibsf1_tm purge;
drop table ${iml_schema}.chn_equip_info_h_nibsf1_op purge;
drop table ${iml_schema}.chn_equip_info_h_nibsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.chn_equip_info_h_nibsf1_tm nologging
compress ${option_switch} for query high
as select
    equip_id -- 设备编号
    ,lp_id -- 法人编号
    ,equip_model -- 设备型号
    ,equip_type_cd -- 设备类型代码
    ,equip_status_cd -- 设备状态代码
    ,equip_use_status_cd -- 设备使用状态代码
    ,in_bank_flg -- 在行标志
    ,install_way_cd -- 安装方式代码
    ,inst_phone -- 安装联系电话
    ,equip_manuf_name -- 设备厂商名称
    ,equip_addr -- 设备地址
    ,equip_ip -- 设备IP
    ,matn_start_dt -- 维保开始日期
    ,matn_end_dt -- 维保结束日期
    ,equip_buy_dt -- 设备购买日期
    ,equip_start_use_dt -- 设备启用日期
    ,equip_stop_dt -- 设备停止日期
    ,self_h_bank_flg -- 自助银行标志
    ,comm_status_flg -- 通讯状态正常标志
    ,move_status_cd -- 运行状态代码
    ,clean_corp_id -- 清机公司编号
    ,clean_corp_name -- 清机公司名称
    ,atm_clean_appl_bind_teller_id -- ATM清机申请绑定柜员编号
    ,outsourc_mgmt_flg -- 外包管理标志
    ,midgrod_inst_code -- 中台装机码
    ,midgrod_sync_flg -- 中台同步标志
    ,vtual_teller_id -- 虚拟柜员编号
    ,belong_org_id -- 所属机构编号
    ,fir_create_dt -- 首次创建日期
    ,fir_create_teller_id -- 首次创建柜员编号
    ,fir_creator_belong_org_id -- 首次创建人所属机构编号
    ,matn_ps_belong_org_cd -- 维护人所属机构代码
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.chn_equip_info_h partition for ('nibsf1')
where 0=1
;

create table ${iml_schema}.chn_equip_info_h_nibsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.chn_equip_info_h partition for ('nibsf1') where 0=1;

create table ${iml_schema}.chn_equip_info_h_nibsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.chn_equip_info_h partition for ('nibsf1') where 0=1;

-- 3.1 get new data into table
-- nibs_ib_dev_device_info-1
insert into ${iml_schema}.chn_equip_info_h_nibsf1_tm(
    equip_id -- 设备编号
    ,lp_id -- 法人编号
    ,equip_model -- 设备型号
    ,equip_type_cd -- 设备类型代码
    ,equip_status_cd -- 设备状态代码
    ,equip_use_status_cd -- 设备使用状态代码
    ,in_bank_flg -- 在行标志
    ,install_way_cd -- 安装方式代码
    ,inst_phone -- 安装联系电话
    ,equip_manuf_name -- 设备厂商名称
    ,equip_addr -- 设备地址
    ,equip_ip -- 设备IP
    ,matn_start_dt -- 维保开始日期
    ,matn_end_dt -- 维保结束日期
    ,equip_buy_dt -- 设备购买日期
    ,equip_start_use_dt -- 设备启用日期
    ,equip_stop_dt -- 设备停止日期
    ,self_h_bank_flg -- 自助银行标志
    ,comm_status_flg -- 通讯状态正常标志
    ,move_status_cd -- 运行状态代码
    ,clean_corp_id -- 清机公司编号
    ,clean_corp_name -- 清机公司名称
    ,atm_clean_appl_bind_teller_id -- ATM清机申请绑定柜员编号
    ,outsourc_mgmt_flg -- 外包管理标志
    ,midgrod_inst_code -- 中台装机码
    ,midgrod_sync_flg -- 中台同步标志
    ,vtual_teller_id -- 虚拟柜员编号
    ,belong_org_id -- 所属机构编号
    ,fir_create_dt -- 首次创建日期
    ,fir_create_teller_id -- 首次创建柜员编号
    ,fir_creator_belong_org_id -- 首次创建人所属机构编号
    ,matn_ps_belong_org_cd -- 维护人所属机构代码
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.DEVICENUM -- 设备编号
    ,'9999' -- 法人编号
    ,P1.DEVMODELID -- 设备型号
    ,nvl(trim(P1.DEVICETYPENUM),'-') -- 设备类型代码
    ,nvl(trim(P1.DEVICESATUS),'-') -- 设备状态代码
    ,nvl(trim(P1.DEVICESTATE),'-') -- 设备使用状态代码
    ,decode(P1.EXISTFALG,'1','1','2','0',' ','-',P1.EXISTFALG) -- 在行标志
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.INSTALLTYPE END -- 安装方式代码
    ,P1.INSTALLCONTEL -- 安装联系电话
    ,P1.MANUFACTURERNAME -- 设备厂商名称
    ,P1.INSTALLADDRESS -- 设备地址
    ,P1.DEVICEIP -- 设备IP
    ,${iml_schema}.dateformat_min(P1.INSUSTARTDATE) -- 维保开始日期
    ,${iml_schema}.dateformat_max2(P1.INSUENDDATE) -- 维保结束日期
    ,${iml_schema}.dateformat_min(P1.DEVICEBUYDATE) -- 设备购买日期
    ,${iml_schema}.dateformat_min(P1.DEVICESTARTDATE||P1.DEVICESERVICESTARTTIME) -- 设备启用日期
    ,${iml_schema}.dateformat_max2(P1.DEVICESTOPDATE||P1.DEVICESERVICEENDTIME) -- 设备停止日期
    ,nvl(trim(P1.SELFBANK),'-') -- 自助银行标志
    ,decode(P1.COMMSTATUS,'1','1','0','-','2','0',' ','-',P1.COMMSTATUS) -- 通讯状态正常标志
    ,nvl(trim(P1.OPERSTATUS),'-') -- 运行状态代码
    ,P1.QJCOM_ID -- 清机公司编号
    ,P1.QJCOMNAME -- 清机公司名称
    ,P1.BANKTELLER -- ATM清机申请绑定柜员编号
    ,decode(P1.MANAGEMENTMODE,'2','1','1','0',' ','-',P1.MANAGEMENTMODE) -- 外包管理标志
    ,P1.AUTHCODE -- 中台装机码
    ,nvl(trim(P1.ASYCNFALG),'-') -- 中台同步标志
    ,P1.VIRTUALUSERNUM -- 虚拟柜员编号
    ,P1.ASCRBRANCH -- 所属机构编号
    ,${iml_schema}.dateformat_min(P1.CREADATE||P1.DEVCREATETIME) -- 首次创建日期
    ,P1.CREAUSER -- 首次创建柜员编号
    ,P1.CREATORBRNO -- 首次创建人所属机构编号
    ,P1.MODIFYUSERBRNO -- 维护人所属机构代码
    ,${iml_schema}.dateformat_max2(P1.MODIFDATE||P1.MODIFTIME) -- 最后修改日期
    ,P1.MODIFYUSER -- 最后修改柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nibs_ib_dev_device_info' -- 源表名称
    ,'nibsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nibs_ib_dev_device_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.INSTALLTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NIBS'
        AND R1.SRC_TAB_EN_NAME= 'NIBS_IB_DEV_DEVICE_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'INSTALLTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'CHN_EQUIP_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INSTALL_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.chn_equip_info_h_nibsf1_tm 
  	                                group by 
  	                                        equip_id
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
        into ${iml_schema}.chn_equip_info_h_nibsf1_cl(
            equip_id -- 设备编号
    ,lp_id -- 法人编号
    ,equip_model -- 设备型号
    ,equip_type_cd -- 设备类型代码
    ,equip_status_cd -- 设备状态代码
    ,equip_use_status_cd -- 设备使用状态代码
    ,in_bank_flg -- 在行标志
    ,install_way_cd -- 安装方式代码
    ,inst_phone -- 安装联系电话
    ,equip_manuf_name -- 设备厂商名称
    ,equip_addr -- 设备地址
    ,equip_ip -- 设备IP
    ,matn_start_dt -- 维保开始日期
    ,matn_end_dt -- 维保结束日期
    ,equip_buy_dt -- 设备购买日期
    ,equip_start_use_dt -- 设备启用日期
    ,equip_stop_dt -- 设备停止日期
    ,self_h_bank_flg -- 自助银行标志
    ,comm_status_flg -- 通讯状态正常标志
    ,move_status_cd -- 运行状态代码
    ,clean_corp_id -- 清机公司编号
    ,clean_corp_name -- 清机公司名称
    ,atm_clean_appl_bind_teller_id -- ATM清机申请绑定柜员编号
    ,outsourc_mgmt_flg -- 外包管理标志
    ,midgrod_inst_code -- 中台装机码
    ,midgrod_sync_flg -- 中台同步标志
    ,vtual_teller_id -- 虚拟柜员编号
    ,belong_org_id -- 所属机构编号
    ,fir_create_dt -- 首次创建日期
    ,fir_create_teller_id -- 首次创建柜员编号
    ,fir_creator_belong_org_id -- 首次创建人所属机构编号
    ,matn_ps_belong_org_cd -- 维护人所属机构代码
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.chn_equip_info_h_nibsf1_op(
            equip_id -- 设备编号
    ,lp_id -- 法人编号
    ,equip_model -- 设备型号
    ,equip_type_cd -- 设备类型代码
    ,equip_status_cd -- 设备状态代码
    ,equip_use_status_cd -- 设备使用状态代码
    ,in_bank_flg -- 在行标志
    ,install_way_cd -- 安装方式代码
    ,inst_phone -- 安装联系电话
    ,equip_manuf_name -- 设备厂商名称
    ,equip_addr -- 设备地址
    ,equip_ip -- 设备IP
    ,matn_start_dt -- 维保开始日期
    ,matn_end_dt -- 维保结束日期
    ,equip_buy_dt -- 设备购买日期
    ,equip_start_use_dt -- 设备启用日期
    ,equip_stop_dt -- 设备停止日期
    ,self_h_bank_flg -- 自助银行标志
    ,comm_status_flg -- 通讯状态正常标志
    ,move_status_cd -- 运行状态代码
    ,clean_corp_id -- 清机公司编号
    ,clean_corp_name -- 清机公司名称
    ,atm_clean_appl_bind_teller_id -- ATM清机申请绑定柜员编号
    ,outsourc_mgmt_flg -- 外包管理标志
    ,midgrod_inst_code -- 中台装机码
    ,midgrod_sync_flg -- 中台同步标志
    ,vtual_teller_id -- 虚拟柜员编号
    ,belong_org_id -- 所属机构编号
    ,fir_create_dt -- 首次创建日期
    ,fir_create_teller_id -- 首次创建柜员编号
    ,fir_creator_belong_org_id -- 首次创建人所属机构编号
    ,matn_ps_belong_org_cd -- 维护人所属机构代码
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.equip_id, o.equip_id) as equip_id -- 设备编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.equip_model, o.equip_model) as equip_model -- 设备型号
    ,nvl(n.equip_type_cd, o.equip_type_cd) as equip_type_cd -- 设备类型代码
    ,nvl(n.equip_status_cd, o.equip_status_cd) as equip_status_cd -- 设备状态代码
    ,nvl(n.equip_use_status_cd, o.equip_use_status_cd) as equip_use_status_cd -- 设备使用状态代码
    ,nvl(n.in_bank_flg, o.in_bank_flg) as in_bank_flg -- 在行标志
    ,nvl(n.install_way_cd, o.install_way_cd) as install_way_cd -- 安装方式代码
    ,nvl(n.inst_phone, o.inst_phone) as inst_phone -- 安装联系电话
    ,nvl(n.equip_manuf_name, o.equip_manuf_name) as equip_manuf_name -- 设备厂商名称
    ,nvl(n.equip_addr, o.equip_addr) as equip_addr -- 设备地址
    ,nvl(n.equip_ip, o.equip_ip) as equip_ip -- 设备IP
    ,nvl(n.matn_start_dt, o.matn_start_dt) as matn_start_dt -- 维保开始日期
    ,nvl(n.matn_end_dt, o.matn_end_dt) as matn_end_dt -- 维保结束日期
    ,nvl(n.equip_buy_dt, o.equip_buy_dt) as equip_buy_dt -- 设备购买日期
    ,nvl(n.equip_start_use_dt, o.equip_start_use_dt) as equip_start_use_dt -- 设备启用日期
    ,nvl(n.equip_stop_dt, o.equip_stop_dt) as equip_stop_dt -- 设备停止日期
    ,nvl(n.self_h_bank_flg, o.self_h_bank_flg) as self_h_bank_flg -- 自助银行标志
    ,nvl(n.comm_status_flg, o.comm_status_flg) as comm_status_flg -- 通讯状态正常标志
    ,nvl(n.move_status_cd, o.move_status_cd) as move_status_cd -- 运行状态代码
    ,nvl(n.clean_corp_id, o.clean_corp_id) as clean_corp_id -- 清机公司编号
    ,nvl(n.clean_corp_name, o.clean_corp_name) as clean_corp_name -- 清机公司名称
    ,nvl(n.atm_clean_appl_bind_teller_id, o.atm_clean_appl_bind_teller_id) as atm_clean_appl_bind_teller_id -- ATM清机申请绑定柜员编号
    ,nvl(n.outsourc_mgmt_flg, o.outsourc_mgmt_flg) as outsourc_mgmt_flg -- 外包管理标志
    ,nvl(n.midgrod_inst_code, o.midgrod_inst_code) as midgrod_inst_code -- 中台装机码
    ,nvl(n.midgrod_sync_flg, o.midgrod_sync_flg) as midgrod_sync_flg -- 中台同步标志
    ,nvl(n.vtual_teller_id, o.vtual_teller_id) as vtual_teller_id -- 虚拟柜员编号
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.fir_create_dt, o.fir_create_dt) as fir_create_dt -- 首次创建日期
    ,nvl(n.fir_create_teller_id, o.fir_create_teller_id) as fir_create_teller_id -- 首次创建柜员编号
    ,nvl(n.fir_creator_belong_org_id, o.fir_creator_belong_org_id) as fir_creator_belong_org_id -- 首次创建人所属机构编号
    ,nvl(n.matn_ps_belong_org_cd, o.matn_ps_belong_org_cd) as matn_ps_belong_org_cd -- 维护人所属机构代码
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.final_modif_teller_id, o.final_modif_teller_id) as final_modif_teller_id -- 最后修改柜员编号
    ,case when
            n.equip_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.equip_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.equip_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.chn_equip_info_h_nibsf1_tm n
    full join (select * from ${iml_schema}.chn_equip_info_h_nibsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.equip_id = n.equip_id
            and o.lp_id = n.lp_id
where (
        o.equip_id is null
        and o.lp_id is null
    )
    or (
        n.equip_id is null
        and n.lp_id is null
    )
    or (
        o.equip_model <> n.equip_model
        or o.equip_type_cd <> n.equip_type_cd
        or o.equip_status_cd <> n.equip_status_cd
        or o.equip_use_status_cd <> n.equip_use_status_cd
        or o.in_bank_flg <> n.in_bank_flg
        or o.install_way_cd <> n.install_way_cd
        or o.inst_phone <> n.inst_phone
        or o.equip_manuf_name <> n.equip_manuf_name
        or o.equip_addr <> n.equip_addr
        or o.equip_ip <> n.equip_ip
        or o.matn_start_dt <> n.matn_start_dt
        or o.matn_end_dt <> n.matn_end_dt
        or o.equip_buy_dt <> n.equip_buy_dt
        or o.equip_start_use_dt <> n.equip_start_use_dt
        or o.equip_stop_dt <> n.equip_stop_dt
        or o.self_h_bank_flg <> n.self_h_bank_flg
        or o.comm_status_flg <> n.comm_status_flg
        or o.move_status_cd <> n.move_status_cd
        or o.clean_corp_id <> n.clean_corp_id
        or o.clean_corp_name <> n.clean_corp_name
        or o.atm_clean_appl_bind_teller_id <> n.atm_clean_appl_bind_teller_id
        or o.outsourc_mgmt_flg <> n.outsourc_mgmt_flg
        or o.midgrod_inst_code <> n.midgrod_inst_code
        or o.midgrod_sync_flg <> n.midgrod_sync_flg
        or o.vtual_teller_id <> n.vtual_teller_id
        or o.belong_org_id <> n.belong_org_id
        or o.fir_create_dt <> n.fir_create_dt
        or o.fir_create_teller_id <> n.fir_create_teller_id
        or o.fir_creator_belong_org_id <> n.fir_creator_belong_org_id
        or o.matn_ps_belong_org_cd <> n.matn_ps_belong_org_cd
        or o.final_modif_dt <> n.final_modif_dt
        or o.final_modif_teller_id <> n.final_modif_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.chn_equip_info_h_nibsf1_cl(
            equip_id -- 设备编号
    ,lp_id -- 法人编号
    ,equip_model -- 设备型号
    ,equip_type_cd -- 设备类型代码
    ,equip_status_cd -- 设备状态代码
    ,equip_use_status_cd -- 设备使用状态代码
    ,in_bank_flg -- 在行标志
    ,install_way_cd -- 安装方式代码
    ,inst_phone -- 安装联系电话
    ,equip_manuf_name -- 设备厂商名称
    ,equip_addr -- 设备地址
    ,equip_ip -- 设备IP
    ,matn_start_dt -- 维保开始日期
    ,matn_end_dt -- 维保结束日期
    ,equip_buy_dt -- 设备购买日期
    ,equip_start_use_dt -- 设备启用日期
    ,equip_stop_dt -- 设备停止日期
    ,self_h_bank_flg -- 自助银行标志
    ,comm_status_flg -- 通讯状态正常标志
    ,move_status_cd -- 运行状态代码
    ,clean_corp_id -- 清机公司编号
    ,clean_corp_name -- 清机公司名称
    ,atm_clean_appl_bind_teller_id -- ATM清机申请绑定柜员编号
    ,outsourc_mgmt_flg -- 外包管理标志
    ,midgrod_inst_code -- 中台装机码
    ,midgrod_sync_flg -- 中台同步标志
    ,vtual_teller_id -- 虚拟柜员编号
    ,belong_org_id -- 所属机构编号
    ,fir_create_dt -- 首次创建日期
    ,fir_create_teller_id -- 首次创建柜员编号
    ,fir_creator_belong_org_id -- 首次创建人所属机构编号
    ,matn_ps_belong_org_cd -- 维护人所属机构代码
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.chn_equip_info_h_nibsf1_op(
            equip_id -- 设备编号
    ,lp_id -- 法人编号
    ,equip_model -- 设备型号
    ,equip_type_cd -- 设备类型代码
    ,equip_status_cd -- 设备状态代码
    ,equip_use_status_cd -- 设备使用状态代码
    ,in_bank_flg -- 在行标志
    ,install_way_cd -- 安装方式代码
    ,inst_phone -- 安装联系电话
    ,equip_manuf_name -- 设备厂商名称
    ,equip_addr -- 设备地址
    ,equip_ip -- 设备IP
    ,matn_start_dt -- 维保开始日期
    ,matn_end_dt -- 维保结束日期
    ,equip_buy_dt -- 设备购买日期
    ,equip_start_use_dt -- 设备启用日期
    ,equip_stop_dt -- 设备停止日期
    ,self_h_bank_flg -- 自助银行标志
    ,comm_status_flg -- 通讯状态正常标志
    ,move_status_cd -- 运行状态代码
    ,clean_corp_id -- 清机公司编号
    ,clean_corp_name -- 清机公司名称
    ,atm_clean_appl_bind_teller_id -- ATM清机申请绑定柜员编号
    ,outsourc_mgmt_flg -- 外包管理标志
    ,midgrod_inst_code -- 中台装机码
    ,midgrod_sync_flg -- 中台同步标志
    ,vtual_teller_id -- 虚拟柜员编号
    ,belong_org_id -- 所属机构编号
    ,fir_create_dt -- 首次创建日期
    ,fir_create_teller_id -- 首次创建柜员编号
    ,fir_creator_belong_org_id -- 首次创建人所属机构编号
    ,matn_ps_belong_org_cd -- 维护人所属机构代码
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.equip_id -- 设备编号
    ,o.lp_id -- 法人编号
    ,o.equip_model -- 设备型号
    ,o.equip_type_cd -- 设备类型代码
    ,o.equip_status_cd -- 设备状态代码
    ,o.equip_use_status_cd -- 设备使用状态代码
    ,o.in_bank_flg -- 在行标志
    ,o.install_way_cd -- 安装方式代码
    ,o.inst_phone -- 安装联系电话
    ,o.equip_manuf_name -- 设备厂商名称
    ,o.equip_addr -- 设备地址
    ,o.equip_ip -- 设备IP
    ,o.matn_start_dt -- 维保开始日期
    ,o.matn_end_dt -- 维保结束日期
    ,o.equip_buy_dt -- 设备购买日期
    ,o.equip_start_use_dt -- 设备启用日期
    ,o.equip_stop_dt -- 设备停止日期
    ,o.self_h_bank_flg -- 自助银行标志
    ,o.comm_status_flg -- 通讯状态正常标志
    ,o.move_status_cd -- 运行状态代码
    ,o.clean_corp_id -- 清机公司编号
    ,o.clean_corp_name -- 清机公司名称
    ,o.atm_clean_appl_bind_teller_id -- ATM清机申请绑定柜员编号
    ,o.outsourc_mgmt_flg -- 外包管理标志
    ,o.midgrod_inst_code -- 中台装机码
    ,o.midgrod_sync_flg -- 中台同步标志
    ,o.vtual_teller_id -- 虚拟柜员编号
    ,o.belong_org_id -- 所属机构编号
    ,o.fir_create_dt -- 首次创建日期
    ,o.fir_create_teller_id -- 首次创建柜员编号
    ,o.fir_creator_belong_org_id -- 首次创建人所属机构编号
    ,o.matn_ps_belong_org_cd -- 维护人所属机构代码
    ,o.final_modif_dt -- 最后修改日期
    ,o.final_modif_teller_id -- 最后修改柜员编号
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
from ${iml_schema}.chn_equip_info_h_nibsf1_bk o
    left join ${iml_schema}.chn_equip_info_h_nibsf1_op n
        on
            o.equip_id = n.equip_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.chn_equip_info_h_nibsf1_cl d
        on
            o.equip_id = d.equip_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.chn_equip_info_h;
--alter table ${iml_schema}.chn_equip_info_h truncate partition for ('nibsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('chn_equip_info_h') 
               and substr(subpartition_name,1,8)=upper('p_nibsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.chn_equip_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.chn_equip_info_h modify partition p_nibsf1 
add subpartition p_nibsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.chn_equip_info_h exchange subpartition p_nibsf1_${batch_date} with table ${iml_schema}.chn_equip_info_h_nibsf1_cl;
alter table ${iml_schema}.chn_equip_info_h exchange subpartition p_nibsf1_20991231 with table ${iml_schema}.chn_equip_info_h_nibsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.chn_equip_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.chn_equip_info_h_nibsf1_tm purge;
drop table ${iml_schema}.chn_equip_info_h_nibsf1_op purge;
drop table ${iml_schema}.chn_equip_info_h_nibsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.chn_equip_info_h_nibsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'chn_equip_info_h', partname => 'p_nibsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
