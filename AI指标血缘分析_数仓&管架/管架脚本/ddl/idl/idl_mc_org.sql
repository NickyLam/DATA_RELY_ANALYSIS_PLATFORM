prompt PL/SQL Developer import file
prompt Created on 2020年8月23日 by wuzheng
set feedback off
set define off
prompt Creating MC_ORG...
drop table MC_ORG cascade constraints;
prompt Creating MC_ORG...
create table MC_ORG
(
  org_no         VARCHAR2(30),
  org_name       VARCHAR2(80),
  super_org_no   VARCHAR2(30),
  super_org_name VARCHAR2(30),
  accts_org_ind  VARCHAR2(30),
  org_status_cd  VARCHAR2(30),
  org_level      VARCHAR2(18),
  org_level_cd   VARCHAR2(30),
  enty_org_flg   VARCHAR2(30),
  org_abbr       VARCHAR2(120),
  remark         VARCHAR2(120),
  etl_dt         DATE
)
;
comment on table MC_ORG
  is '组织机构表';
comment on column MC_ORG.org_no
  is '机构编号';
comment on column MC_ORG.org_name
  is '机构名称';
comment on column MC_ORG.super_org_no
  is '上级机构';
comment on column MC_ORG.super_org_name
  is '上级机构名称';
comment on column MC_ORG.accts_org_ind
  is '机构层级';
comment on column MC_ORG.org_status_cd
  is '机构标识';
comment on column MC_ORG.org_level
  is '业务级别';
comment on column MC_ORG.org_level_cd
  is '业务级别编号';
comment on column MC_ORG.enty_org_flg
  is '实体机构标志';
comment on column MC_ORG.org_abbr
  is '机构全称';
comment on column MC_ORG.remark
  is '备注';
comment on column MC_ORG.etl_dt
  is '数据日期';

prompt Loading MC_ORG...
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('000000', '全行', '000000', null, '0', '2', null, '0', null, '广东华兴银行股份有限公司', null, to_date('31-03-2020', 'dd-mm-yyyy'));
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('801', '广州分行', '000000', null, '0', '2', '1', '10', '10', '广东华兴银行股份有限公司广州分行', null, to_date('31-03-2020', 'dd-mm-yyyy'));
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('802', '汕头分行', '000000', null, '0', '2', '2', '10', '10', '广东华兴银行股份有限公司汕头分行', null, to_date('31-03-2020', 'dd-mm-yyyy'));
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('803', '佛山分行', '000000', null, '0', '2', '2', '10', '10', '广东华兴银行股份有限公司佛山分行', null, to_date('31-03-2020', 'dd-mm-yyyy'));
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('805', '深圳分行', '000000', null, '0', '2', '1', '10', '10', '广东华兴银行股份有限公司深圳分行', null, to_date('31-03-2020', 'dd-mm-yyyy'));
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('806', '东莞分行', '000000', null, '0', '2', '2', '10', '10', '广东华兴银行股份有限公司东莞分行', null, to_date('31-03-2020', 'dd-mm-yyyy'));
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('807', '中山分行', '000000', null, '0', '2', '3', '10', '10', '广东华兴银行股份有限公司中山分行', null, to_date('31-03-2020', 'dd-mm-yyyy'));
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('808', '江门分行', '000000', null, '0', '2', '3', '10', '10', '广东华兴银行股份有限公司江门分行', null, to_date('31-03-2020', 'dd-mm-yyyy'));
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('809', '珠海分行', '000000', null, '0', '2', '3', '10', '10', '广东华兴银行股份有限公司珠海分行', null, to_date('31-03-2020', 'dd-mm-yyyy'));
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('810', '惠州分行', '000000', null, '0', '2', '3', '10', '10', '广东华兴银行股份有限公司惠州分行', null, to_date('31-03-2020', 'dd-mm-yyyy'));
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('800935', '票据业务事业部', '800', null, '0', '2', null, '0', null, '票据业务事业部', null, to_date('31-03-2020', 'dd-mm-yyyy'));
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('800976', '资金交易部', '800', null, '0', '2', null, '10', null, '资金交易部', null, to_date('31-03-2020', 'dd-mm-yyyy'));
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('800993', '供应链金融事业部', '800', null, '0', '2', null, '0', null, '供应链金融事业部', null, to_date('31-03-2020', 'dd-mm-yyyy'));
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('800996', '私人银行事业部', '800', null, '0', '2', null, '0', null, '私人银行事业部（财富管理部）', null, to_date('31-03-2020', 'dd-mm-yyyy'));
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('897001', '互联网银行事业部', '897', null, '1', '2', null, '10', null, '互联网银行事业部', null, to_date('31-03-2020', 'dd-mm-yyyy'));
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('898001', '普惠金融事业部', '898', null, '1', '2', null, '10', null, '普惠金融事业部', null, to_date('31-03-2020', 'dd-mm-yyyy'));
insert into MC_ORG (org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, remark, etl_dt)
values ('899001', '资产管理事业部', '899', null, '0', '2', null, '10', null, '资产管理事业部', null, to_date('31-03-2020', 'dd-mm-yyyy'));
commit;
prompt 17 records loaded
set feedback on
set define on
prompt Done.
